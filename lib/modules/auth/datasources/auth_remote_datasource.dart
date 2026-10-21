import '../../../core/network/dio_client.dart';
import '../../../core/storage/local_database_helper.dart';
import '../../../data/models/login_request_model.dart';
import '../../../data/models/login_response_model.dart';
import '../../../data/models/register_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/models/session_model.dart';

class AuthRemoteDataSource {
  final DioClient dioClient;

  AuthRemoteDataSource({required this.dioClient});

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final identifier = request.identifier.trim().toLowerCase();

    int roleId = 3;
    String name = 'Rahul Player';
    String token = 'mock_player_token_123';
    String email = identifier.contains('@') ? identifier : 'player@gmail.com';
    String phone = '9988776655';

    if (identifier.contains('admin') ||
        identifier == 'aadiverma4206@gmail.com') {
      roleId = 1;
      name = 'Aadi Verma (Admin)';
      token = 'mock_admin_token_123';
      email = 'aadiverma4206@gmail.com';
      phone = '9876543210';
    } else if (identifier.contains('roshan') ||
        identifier == 'roshan12@gmail.com') {
      roleId = 2;
      name = 'Roshan Sharma (Manager)';
      token = 'mock_manager_token_123';
      email = 'roshan12@gmail.com';
      phone = '9123456789';
    } else {
      roleId = 3;
      name = 'Rahul Player';
      token = 'mock_player_token_123';
      email = identifier.contains('@') ? identifier : 'player@gmail.com';
      phone = '9988776655';
    }

    final user = UserModel(
      id: roleId.toString(),
      name: name,
      email: email,
      phone: phone,
      roleId: roleId,
      roleName: roleId == 1 ? 'Admin' : (roleId == 2 ? 'Manager' : 'Player'),
      city: 'Raipur',
      status: 'ACTIVE',
    );

    return LoginResponseModel(
      user: user,
      accessToken: token,
      refreshToken: 'mock_refresh_123',
      expiresInSeconds: 3600,
    );
  }

  Future<UserModel> getMe() async {
    return UserModel(
      id: '3',
      name: 'Rahul Player',
      email: 'player@gmail.com',
      phone: '9988776655',
      roleId: 3,
      roleName: 'Player',
      city: 'Raipur',
      status: 'ACTIVE',
    );
  }

  Future<void> sendRegisterOtp(RegisterSendOtpRequestModel request) async {}
  Future<String> verifyRegisterOtp(
      RegisterVerifyOtpRequestModel request) async {
    return 'mock_token';
  }

  Future<LoginResponseModel> registerPlayer(
      RegisterPlayerRequestModel request) async {
    final user = UserModel(
      id: '3',
      name: request.name,
      email: request.email,
      phone: request.phone,
      roleId: 3,
      roleName: 'Player',
      city: request.city,
      status: 'ACTIVE',
    );
    return LoginResponseModel(
      user: user,
      accessToken: 'token',
      refreshToken: 'refresh',
      expiresInSeconds: 3600,
    );
  }

  Future<void> forgotSendOtp(String identifier) async {}
  Future<String> forgotVerifyOtp(String identifier, String otp) async {
    return 'token';
  }

  Future<void> resetPassword(String token, String newPassword) async {}

  Future<List<SessionModel>> getSessions() async {
    return [
      SessionModel(
        id: 'sess_1',
        deviceInfo: 'Android Simulator (SMASH UP INDIA)',
        ipAddress: '192.168.1.10',
        createdAt: DateTime.now().toIso8601String(),
        expiresAt:
            DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      ),
    ];
  }

  Future<void> revokeSession(String id) async {}
}
