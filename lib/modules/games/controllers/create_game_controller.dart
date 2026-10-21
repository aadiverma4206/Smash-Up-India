import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import '../repositories/games_repository.dart';
import '../../wallet/repositories/wallet_repository.dart';
import '../../wallet/datasources/wallet_remote_datasource.dart';
import '../../../data/models/court_model.dart';
import '../../../data/models/football_game_type.dart';
import '../../../core/network/dio_client.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/utils/app_logger.dart';
import '../../../core/utils/app_date_utils.dart';
import '../../../app/routes/app_routes.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/storage/local_database_helper.dart';
import '../../../core/storage/preferences_service.dart';

class CreateGameController extends GetxController {
  final GamesRepository repository = Get.find<GamesRepository>();
  final PreferencesService _prefs = Get.find<PreferencesService>();

  WalletRepository get _walletRepo {
    if (Get.isRegistered<WalletRepository>()) {
      return Get.find<WalletRepository>();
    } else {
      final dio = Get.find<DioClient>();
      final ds = WalletRemoteDataSource(dioClient: dio);
      return WalletRepository(remoteDataSource: ds);
    }
  }

  late Razorpay _razorpay;

  final formKey = GlobalKey<FormState>();

  // Text Controllers
  final titleController = TextEditingController();
  final entryFeeController = TextEditingController();
  final reservePlayersController = TextEditingController();
  final descriptionController = TextEditingController();

  final entryFeeRx = ''.obs;
  final reserveCountRx = ''.obs;

  // Fixed Venue & Court options
  final availableClubs = <ClubModel>[].obs;
  final Rx<ClubModel> selectedClub = ClubModel(
    id: 'clb_all_stars_turf_raipur',
    name: 'All Stars Turf Raipur',
    city: 'Raipur',
    address: 'Raipur',
  ).obs;

  final availableCourts = <CourtModel>[].obs;
  final Rxn<CourtModel> selectedCourt = Rxn<CourtModel>();

  // Game Category and Type
  final Rxn<GameCategory> selectedCategory = Rxn<GameCategory>();
  final availableGameTypes = <FootballGameType>[].obs;
  final Rxn<FootballGameType> selectedGameType = Rxn<FootballGameType>();

  final selectedSport = 'Football'.obs;
  final selectedFormat = ''.obs;
  final maxPlayers = 0.obs;

  void updateFormatAndPlayers(String format) {
    selectedFormat.value = format;
    switch (format) {
      case '11v11':
        maxPlayers.value = 22;
        break;
      case '9v9':
        maxPlayers.value = 18;
        break;
      case '7v7':
        maxPlayers.value = 14;
        break;
      case '6v6':
        maxPlayers.value = 12;
        break;
      case '5v5':
        maxPlayers.value = 10;
        break;
      case '3v3':
        maxPlayers.value = 6;
        break;
      case '2v2':
        maxPlayers.value = 4;
        break;
      case '1v1':
        maxPlayers.value = 2;
        break;
      default:
        maxPlayers.value = 22;
        break;
    }
  }

  Future<void> onCategoryChanged(GameCategory? category) async {
    if (category == null || category == selectedCategory.value) return;

    selectedCategory.value = category;
    selectedGameType.value = null;
    selectedFormat.value = '';
    maxPlayers.value = 0;
    availableGameTypes.clear();

    await _prefs.setLastGameCategory(category.value);

    await loadGameTypes(category.value);
  }

  Future<void> loadGameTypes(String categoryStr) async {
    try {
      final dbHelper = LocalDatabaseHelper.instance;
      final results = await dbHelper.getFootballGamesByCategory(categoryStr);
      final games = results.map((e) => FootballGameType.fromMap(e)).toList();
      availableGameTypes.assignAll(games);
    } catch (e) {
      AppLogger.warning('Error loading game types from DB: $e');
    }
  }

  void onGameTypeChanged(FootballGameType? game) {
    if (game == null) return;
    selectedGameType.value = game;
    updateFormatAndPlayers(game.format);
    _prefs.setLastGameTypeId(game.id);
  }

  // Unselected initial state for Skill level & Date/Times
  final skillRequirement = RxnString();
  final privacy = 'PUBLIC'.obs;

  final Rxn<DateTime> selectedDate = Rxn<DateTime>();
  final Rxn<TimeOfDay> startTime = Rxn<TimeOfDay>();
  final Rxn<TimeOfDay> endTime = Rxn<TimeOfDay>();

  final isLoading = false.obs;
  final isProcessing = false.obs;
  final paymentStatus = ''.obs;
  final errorMessage = ''.obs;

  final selectedPaymentMethod = 'RAZORPAY'.obs;
  final walletBalance = 0.0.obs;

  final skills = ['BEGINNER', 'INTERMEDIATE', 'ADVANCED', 'PRO', 'ANY'];

  @override
  void onInit() {
    super.onInit();
    _initRazorpay();
    loadVenues();
    fetchWalletBalance();
    _loadInitialCategoryAndGame();

    entryFeeController.addListener(() {
      entryFeeRx.value = entryFeeController.text.trim();
    });
    reservePlayersController.addListener(() {
      reserveCountRx.value = reservePlayersController.text.trim();
    });
  }

  Future<void> _loadInitialCategoryAndGame() async {
    final lastCat = _prefs.getLastGameCategory();
    if (lastCat != null) {
      final parsedCat = GameCategory.fromString(lastCat);
      if (parsedCat != null) {
        selectedCategory.value = parsedCat;
        await loadGameTypes(parsedCat.value);

        final lastGameId = _prefs.getLastGameTypeId();
        if (lastGameId != null && availableGameTypes.isNotEmpty) {
          final found =
              availableGameTypes.firstWhereOrNull((g) => g.id == lastGameId);
          if (found != null) {
            onGameTypeChanged(found);
          }
        }
      }
    }
  }

  @override
  void onClose() {
    _razorpay.clear();
    titleController.dispose();
    entryFeeController.dispose();
    reservePlayersController.dispose();
    descriptionController.dispose();
    super.onClose();
  }

  void _initRazorpay() {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  Future<void> loadVenues() async {
    try {
      final fetchedClubs = await repository.getClubs();
      if (fetchedClubs.isNotEmpty) {
        availableClubs.assignAll(fetchedClubs);
        selectedClub.value = fetchedClubs.first;
      }
      final fetchedCourts =
          await repository.getCourts(clubId: selectedClub.value.id);
      _populateCourts(fetchedCourts);
    } catch (e) {
      AppLogger.warning('Error loading venues: $e');
      _populateCourts([]);
    }
  }

  Future<void> onClubChanged(ClubModel club) async {
    selectedClub.value = club;
    try {
      final fetchedCourts = await repository.getCourts(clubId: club.id);
      _populateCourts(fetchedCourts);
    } catch (e) {
      AppLogger.warning('Error loading courts: $e');
      _populateCourts([]);
    }
  }

  void _populateCourts(List<CourtModel> fetchedCourts) {
    final court1 = CourtModel(
      id: 'crt_court_1',
      clubId: selectedClub.value.id,
      clubName: selectedClub.value.name,
      name: 'Court 1',
      surfaceType: 'Turf',
      basePricePerHour: 1200.0,
      status: 'AVAILABLE',
      city: 'Raipur',
      address: 'Raipur',
    );

    final court2 = CourtModel(
      id: 'crt_court_2',
      clubId: selectedClub.value.id,
      clubName: selectedClub.value.name,
      name: 'Court 2',
      surfaceType: 'Turf',
      basePricePerHour: 1200.0,
      status: 'AVAILABLE',
      city: 'Raipur',
      address: 'Raipur',
    );

    if (fetchedCourts.isNotEmpty) {
      final courtsList = <CourtModel>[];
      for (int i = 0; i < fetchedCourts.length; i++) {
        final c = fetchedCourts[i];
        final courtName =
            (c.name.toLowerCase().contains('court 2') || c.id.endsWith('2'))
                ? 'Court 2'
                : (i == 0 ? 'Court 1' : (i == 1 ? 'Court 2' : c.name));
        courtsList.add(CourtModel(
          id: c.id.isNotEmpty ? c.id : 'crt_court_${i + 1}',
          clubId: c.clubId.isNotEmpty ? c.clubId : selectedClub.value.id,
          clubName: c.clubName,
          name: courtName,
          surfaceType: c.surfaceType,
          basePricePerHour: c.basePricePerHour,
          status: c.status,
          city: c.city,
          address: c.address,
        ));
      }

      if (!courtsList.any((c) => c.name == 'Court 1')) {
        courtsList.insert(0, court1);
      }
      if (!courtsList.any((c) => c.name == 'Court 2')) {
        courtsList.add(court2);
      }

      availableCourts.assignAll(courtsList);
    } else {
      availableCourts.assignAll([court1, court2]);
    }

    if (selectedCourt.value == null ||
        !availableCourts.contains(selectedCourt.value)) {
      selectedCourt.value = availableCourts.first;
    }
  }

  Future<void> fetchWalletBalance() async {
    try {
      final w = await _walletRepo.getWallet();
      walletBalance.value = w.balance;
    } catch (_) {
      walletBalance.value = 0.0;
    }
  }

  void updateDate(DateTime pickedDate) {
    selectedDate.value = pickedDate;
    final now = DateTime.now();

    if (pickedDate.year == now.year &&
        pickedDate.month == now.month &&
        pickedDate.day == now.day) {
      final currentStart = startTime.value != null
          ? DateTime(now.year, now.month, now.day, startTime.value!.hour,
              startTime.value!.minute)
          : null;
      if (currentStart != null && currentStart.isBefore(now)) {
        final nextStartHour = (now.hour + 1) % 24;
        startTime.value = TimeOfDay(hour: nextStartHour, minute: 0);
        endTime.value = TimeOfDay(hour: (nextStartHour + 1) % 24, minute: 30);
      }
    }
  }

  void updateStartTime(TimeOfDay newStart) {
    startTime.value = newStart;
    final startMinutes = newStart.hour * 60 + newStart.minute;
    final autoEndMinutes = (startMinutes + 90) % (24 * 60);
    endTime.value =
        TimeOfDay(hour: autoEndMinutes ~/ 60, minute: autoEndMinutes % 60);
  }

  void updateEndTime(TimeOfDay newEnd) {
    if (startTime.value == null) {
      endTime.value = newEnd;
      return;
    }

    final startMinutes = startTime.value!.hour * 60 + startTime.value!.minute;
    final endMinutes = newEnd.hour * 60 + newEnd.minute;

    if (endMinutes <= startMinutes && newEnd.hour >= startTime.value!.hour) {
      ErrorHandler.showErrorSnackBar(
        'Invalid End Time',
        'Match end time must be after start time (${AppDateUtils.formatTime(startTime.value!)})',
      );
      final autoEndMinutes = (startMinutes + 90) % (24 * 60);
      endTime.value =
          TimeOfDay(hour: autoEndMinutes ~/ 60, minute: autoEndMinutes % 60);
      return;
    }
    endTime.value = newEnd;
  }

  bool validateForm() {
    if (!formKey.currentState!.validate()) {
      ErrorHandler.showErrorSnackBar(
          'Validation Error', 'Please fill in all required fields');
      return false;
    }

    if (selectedCourt.value == null) {
      ErrorHandler.showErrorSnackBar(
          'Validation Error', 'Please select a court');
      return false;
    }

    if (selectedCategory.value == null) {
      ErrorHandler.showErrorSnackBar(
          'Validation Error', 'Please select Game Category (Indoor/Outdoor)');
      return false;
    }

    if (selectedGameType.value == null) {
      ErrorHandler.showErrorSnackBar(
          'Validation Error', 'Please select a Game Type');
      return false;
    }

    if (selectedFormat.value.isEmpty) {
      ErrorHandler.showErrorSnackBar(
          'Validation Error', 'Game Format is not available for selected game');
      return false;
    }

    if (skillRequirement.value == null || skillRequirement.value!.isEmpty) {
      ErrorHandler.showErrorSnackBar(
          'Validation Error', 'Please select required skill level');
      return false;
    }

    if (selectedDate.value == null) {
      ErrorHandler.showErrorSnackBar(
          'Validation Error', 'Please select a match date');
      return false;
    }

    if (startTime.value == null || endTime.value == null) {
      ErrorHandler.showErrorSnackBar(
          'Validation Error', 'Please select start and end times');
      return false;
    }

    final err = AppDateUtils.validateGameTimes(
      selectedDate.value!,
      startTime.value!,
      endTime.value!,
    );

    if (err != null) {
      ErrorHandler.showErrorSnackBar('Validation Error', err);
      return false;
    }

    final fee = double.tryParse(entryFeeController.text.trim()) ?? -1.0;
    if (fee < 0) {
      ErrorHandler.showErrorSnackBar(
          'Validation Error', 'Please enter a valid non-negative entry fee');
      return false;
    }

    return true;
  }

  void proceedToCheckout() {
    if (!validateForm()) return;
    Get.toNamed('/games/checkout');
  }

  Future<void> executePaymentAndCreateGame() async {
    isProcessing.value = true;
    final userRole =
        AuthService.to.currentUser.value?.roleName?.toUpperCase() ?? '';
    final isManagerOrAdmin = userRole == 'MANAGER' || userRole == 'ADMIN';

    if (!isManagerOrAdmin && selectedPaymentMethod.value == 'WALLET') {
      final fee = double.tryParse(entryFeeController.text.trim()) ?? 0.0;
      if (fee > 0) {
        isProcessing.value = false;
        _promptPinAndAuthorizeWalletPayment(fee: fee);
        return;
      }
    }

    paymentStatus.value = 'Creating Game...';
    await _createGameOnServer();
  }

  void _promptPinAndAuthorizeWalletPayment({required double fee}) {
    final pinController = TextEditingController();

    Get.dialog(
      Builder(
        builder: (context) {
          return AlertDialog(
            backgroundColor: context.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: context.borderColor),
            ),
            title: Row(
              children: [
                const Icon(Icons.shield_rounded,
                    color: AppColors.primary, size: 24),
                const SizedBox(width: 8),
                Text('Authorize Payment',
                    style: TextStyle(color: context.textPrimary, fontSize: 18)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter your 6-digit Wallet PIN to authorize game creation fee of ₹${fee.toStringAsFixed(0)}.',
                    style:
                        TextStyle(color: context.textSecondary, fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: pinController,
                    obscureText: true,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    style: TextStyle(
                        color: context.textPrimary,
                        fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      hintText: 'Enter 6-digit PIN',
                      hintStyle:
                          TextStyle(color: context.textSecondary, fontSize: 13),
                      counterText: '',
                      prefixIcon: const Icon(Icons.lock_outline_rounded,
                          color: AppColors.primary),
                      filled: true,
                      fillColor: context.backgroundColor,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: context.borderColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Cancel',
                    style: TextStyle(color: context.textSecondary)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  final pin = pinController.text.trim();
                  if (pin.length != 6) {
                    ErrorHandler.showErrorSnackBar(
                        'Invalid PIN', 'Please enter a 6-digit PIN');
                    return;
                  }

                  try {
                    Get.back();
                    isProcessing.value = true;
                    paymentStatus.value = 'Authorizing & Creating Game...';
                    await _createGameOnServer(walletPin: pin);
                  } catch (e) {
                    isProcessing.value = false;
                    ErrorHandler.showErrorSnackBar('Authorization Failed', e);
                  }
                },
                child: const Text('Authorize & Create',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> processTestModePayment() async {
    isProcessing.value = true;
    paymentStatus.value = 'Creating Order...';
    await Future.delayed(const Duration(milliseconds: 500));

    paymentStatus.value = 'Opening Razorpay Gateway (Test Mode)...';
    await Future.delayed(const Duration(milliseconds: 600));

    paymentStatus.value = 'Verifying Payment...';
    await Future.delayed(const Duration(milliseconds: 600));

    paymentStatus.value = 'Finalizing Game Creation...';
    await Future.delayed(const Duration(milliseconds: 500));

    await _createGameOnServer();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    paymentStatus.value = 'Verifying Payment...';

    try {
      if (response.orderId != null && response.orderId!.isNotEmpty) {
        await _walletRepo.verifyTopupPayment(
          razorpayOrderId: response.orderId!,
          razorpayPaymentId: response.paymentId ?? '',
          razorpaySignature: response.signature ?? '',
        );
      }

      paymentStatus.value = 'Finalizing Game Creation...';
      await _createGameOnServer(
        paymentId: response.paymentId,
        razorpayOrderId: response.orderId,
        razorpaySignature: response.signature,
      );
    } catch (e) {
      isProcessing.value = false;
      ErrorHandler.showErrorSnackBar('Verification Error', e);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    isProcessing.value = false;
    AppLogger.error(
        '❌ Razorpay Payment Error: ${response.code} - ${response.message}');
    ErrorHandler.showErrorSnackBar(
      'Payment Failed',
      response.message ?? 'Payment was cancelled or failed.',
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    AppLogger.info('External wallet selected: ${response.walletName}');
  }

  Future<void> _createGameOnServer({
    String? paymentId,
    String? walletPin,
    String? razorpayOrderId,
    String? razorpaySignature,
  }) async {
    final club = selectedClub.value;
    final court = selectedCourt.value;

    final courtId = court?.id ?? '';
    final courtName = court?.name ?? 'Court 1';

    final dateStr = selectedDate.value != null
        ? AppDateUtils.formatIsoDate(selectedDate.value!)
        : AppDateUtils.formatIsoDate(
            DateTime.now().add(const Duration(days: 1)));
    final startStr = startTime.value != null
        ? AppDateUtils.format24HourTime(startTime.value!)
        : '18:00';
    final endStr = endTime.value != null
        ? AppDateUtils.format24HourTime(endTime.value!)
        : '19:30';

    final fee = double.tryParse(entryFeeController.text.trim()) ?? 0.0;
    final reserveCount =
        int.tryParse(reservePlayersController.text.trim()) ?? 0;

    try {
      final newGame = await repository.createGame({
        'title': titleController.text.trim().isEmpty
            ? 'Football Game'
            : titleController.text.trim(),
        'clubId': club.id,
        'courtId': courtId,
        'courtName': courtName,
        'sport': selectedSport.value,
        'format': selectedFormat.value,
        'category': selectedCategory.value?.value,
        'gameTypeId': selectedGameType.value?.id,
        'gameName': selectedGameType.value?.name,
        'maxPlayers': maxPlayers.value,
        'reservePlayersCount': reserveCount,
        'entryFee': fee,
        'skillRequirement': skillRequirement.value ?? 'ANY',
        'privacy': privacy.value,
        'matchDate': dateStr,
        'startTime': startStr,
        'endTime': endStr,
        'description': descriptionController.text.trim(),
        'paymentMethod': selectedPaymentMethod.value,
        if (walletPin != null && walletPin.isNotEmpty) 'walletPin': walletPin,
        if (paymentId != null) 'paymentReference': paymentId,
        if (razorpayOrderId != null) 'razorpayOrderId': razorpayOrderId,
        if (razorpaySignature != null) 'razorpaySignature': razorpaySignature,
      });

      await fetchWalletBalance();
      isProcessing.value = false;

      Get.offAllNamed(Routes.home);
      Get.toNamed('/payment/result', arguments: {
        'success': true,
        'amount': fee.toStringAsFixed(0),
        'gameTitle': newGame.title,
        'gameId': newGame.id,
      });
    } catch (e) {
      isProcessing.value = false;
      errorMessage.value = ErrorHandler.getErrorMessage(e);
      ErrorHandler.showErrorSnackBar('Game Creation Error', e);
    }
  }
}
