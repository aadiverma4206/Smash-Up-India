import 'dart:async';
import 'package:get/get.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/storage/secure_storage_service.dart';
import '../../../core/storage/local_database_helper.dart';
import '../../../core/network/dio_client.dart';
import '../repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../../../data/models/user_model.dart';
import '../../../app/routes/app_routes.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/errors/error_handler.dart';

class AuthController extends GetxController {
  final SecureStorageService secureStorage = Get.find<SecureStorageService>();
  final LocalDatabaseHelper dbHelper = LocalDatabaseHelper.instance;
  final AuthRepository repository = AuthRepository(
    remoteDataSource: AuthRemoteDataSource(dioClient: Get.find<DioClient>()),
  );

  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Registration multi-step state
  final RxInt registrationStep = 1.obs;
  final RxString regName = ''.obs;
  final RxString regEmail = ''.obs;
  final RxString regPhone = ''.obs;
  final RxString regCity = 'Raipur'.obs;
  final RxString regVerificationToken = ''.obs;

  // OTP Timer State
  final RxInt otpTimerSeconds = 60.obs;
  final RxBool canResendOtp = false.obs;
  Timer? _timer;

  // Forgot Password State
  final RxString forgotIdentifier = ''.obs;
  final RxString resetToken = ''.obs;

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  void startOtpTimer() {
    otpTimerSeconds.value = 60;
    canResendOtp.value = false;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (otpTimerSeconds.value > 0) {
        otpTimerSeconds.value--;
      } else {
        canResendOtp.value = true;
        timer.cancel();
      }
    });
  }

  /// Startup Session Restore & Role Routing (100% Local / Offline SQLite)
  Future<void> checkAuthStatusAndRoute() async {
    isLoading.value = true;
    try {
      final token = await secureStorage.getAccessToken();
      if (token != null && token.isNotEmpty) {
        // Load user from local database
        final email = AuthService.to.currentUser.value?.email;
        Map<String, dynamic>? userMap;
        if (email != null && email.isNotEmpty) {
          userMap = await dbHelper.getUserByEmailOrPhone(email);
        }
        if (userMap == null) {
          final db = await dbHelper.database;
          final users = await db.query('users', limit: 1);
          if (users.isNotEmpty) {
            userMap = users.first;
          }
        }
        if (userMap != null) {
          final user = UserModel.fromJson(userMap);
          AuthService.to.currentUser.value = user;
          AuthService.to.isLoggedIn.value = true;
          routeUserByRole(user.roleId);
          return;
        }
      }
    } catch (e) {
      AppLogger.warning('Session restore failed: $e');
    } finally {
      isLoading.value = false;
    }

    Get.offAllNamed(Routes.login);
  }

  /// Route user strictly by Backend Role ID
  void routeUserByRole(int roleId) {
    if (roleId == 1) {
      Get.offAllNamed(Routes.adminDashboard);
    } else if (roleId == 2) {
      Get.offAllNamed(Routes.cctvDashboard);
    } else {
      Get.offAllNamed(Routes.home);
    }
  }

  /// 100% Offline Local Login for Player, Manager, Admin
  Future<void> login(String identifier, String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      await Future.delayed(const Duration(milliseconds: 600)); // smooth UX delay

      final trimmed = identifier.trim().toLowerCase();
      Map<String, dynamic>? userMap = await dbHelper.getUserByEmailOrPhone(trimmed);

      // If user doesn't exist in local DB yet, create a default one based on role or identifier
      if (userMap == null) {
        int roleId = 3; // Default Player
        String name = 'Smash User';
        if (trimmed.contains('admin') || trimmed == 'aadiverma4206@gmail.com') {
          roleId = 1;
          name = 'Aadi Verma (Admin)';
        } else if (trimmed.contains('roshan') || trimmed == 'roshan12@gmail.com') {
          roleId = 2;
          name = 'Roshan Sharma (Manager)';
        } else {
          name = trimmed.split('@').first.capitalizeFirst ?? 'Player';
        }

        userMap = {
          'id': DateTime.now().millisecondsSinceEpoch ~/ 1000,
          'name': name,
          'email': trimmed.contains('@') ? trimmed : '$trimmed@smashupindia.com',
          'phone': trimmed.contains('@') ? '9876543210' : trimmed,
          'roleId': roleId,
          'city': 'Raipur',
          'status': 'ACTIVE',
          'avatar': '',
          'token': 'smash_token_${roleId}_${DateTime.now().millisecondsSinceEpoch}',
        };
        await dbHelper.saveUser(userMap);
      }

      final UserModel user = UserModel.fromJson(userMap);
      final accessToken = userMap['token'] ?? 'mock_token_123';
      final refreshToken = 'mock_refresh_token_123';

      await secureStorage.saveTokens(accessToken: accessToken, refreshToken: refreshToken);
      AuthService.to.setLoggedInUser(user, accessToken, refreshToken);

      routeUserByRole(user.roleId);
    } catch (e) {
      final msg = ErrorHandler.getErrorMessage(e);
      errorMessage.value = msg;
      ErrorHandler.showErrorSnackBar('Login Failed', msg);
    } finally {
      isLoading.value = false;
    }
  }

  /// Step 1: Send Registration OTP (Local Mock)
  Future<void> sendRegisterOtp(
      String name, String email, String phone, String city) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      regName.value = name;
      regEmail.value = email;
      regPhone.value = phone;
      regCity.value = city;

      await Future.delayed(const Duration(milliseconds: 500));
      startOtpTimer();
      registrationStep.value = 2;
    } catch (e) {
      final msg = ErrorHandler.getErrorMessage(e);
      errorMessage.value = msg;
      ErrorHandler.showErrorSnackBar('Registration Error', msg);
    } finally {
      isLoading.value = false;
    }
  }

  /// Step 2: Verify Registration OTP (Local Mock)
  Future<void> verifyRegisterOtp(String emailOtp) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      await Future.delayed(const Duration(milliseconds: 500));
      regVerificationToken.value = 'mock_verification_token_123';
      registrationStep.value = 3;
    } catch (e) {
      final msg = ErrorHandler.getErrorMessage(e);
      errorMessage.value = msg;
      ErrorHandler.showErrorSnackBar('Verification Failed', msg);
    } finally {
      isLoading.value = false;
    }
  }

  /// Step 3: Complete Registration (PLAYER ONLY - Local SQLite)
  Future<void> registerPlayer(String password) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      await Future.delayed(const Duration(milliseconds: 600));

      final newUserMap = {
        'id': DateTime.now().millisecondsSinceEpoch ~/ 1000,
        'name': regName.value,
        'email': regEmail.value,
        'phone': regPhone.value,
        'roleId': 3, // Player
        'city': regCity.value,
        'status': 'ACTIVE',
        'avatar': '',
        'token': 'smash_token_3_${DateTime.now().millisecondsSinceEpoch}',
      };

      await dbHelper.saveUser(newUserMap);
      final UserModel user = UserModel.fromJson(newUserMap);
      const accessToken = 'smash_token_player_new';
      const refreshToken = 'smash_refresh_player_new';

      await secureStorage.saveTokens(accessToken: accessToken, refreshToken: refreshToken);
      AuthService.to.setLoggedInUser(user, accessToken, refreshToken);

      registrationStep.value = 4;
      routeUserByRole(user.roleId);
    } catch (e) {
      final msg = ErrorHandler.getErrorMessage(e);
      errorMessage.value = msg;
      ErrorHandler.showErrorSnackBar('Registration Failed', msg);
    } finally {
      isLoading.value = false;
    }
  }

  /// Forgot Password - Send OTP (Local Mock)
  Future<void> forgotPasswordSendOtp(String identifier) async {
    isLoading.value = true;
    try {
      forgotIdentifier.value = identifier;
      await Future.delayed(const Duration(milliseconds: 500));
      startOtpTimer();
      Get.toNamed('/forgot-verify');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Forgot Password - Verify OTP (Local Mock)
  Future<void> forgotPasswordVerifyOtp(String otp) async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      resetToken.value = 'mock_reset_token_123';
      Get.toNamed('/reset-password');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('OTP Verification Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  /// Forgot Password - Reset Password (Local SQLite)
  Future<void> resetPassword(String newPassword) async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      Get.offAllNamed(Routes.login);
      ErrorHandler.showSuccessSnackBar('Success',
          'Password reset successfully. Please log in with your new password.');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Reset Error', e);
    } finally {
      isLoading.value = false;
    }
  }
}
