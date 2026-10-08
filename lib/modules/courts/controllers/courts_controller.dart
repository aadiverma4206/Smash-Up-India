import 'package:get/get.dart';
import '../../../core/network/dio_client.dart';
import '../../../data/models/court_model.dart';
import '../../../data/models/booking_model.dart';
import '../../../core/errors/error_handler.dart';

class CourtsController extends GetxController {
  final DioClient dioClient = Get.find<DioClient>();

  final RxList<CourtModel> courts = <CourtModel>[].obs;
  final RxList<BookingModel> bookings = <BookingModel>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchCourts();
  }

  Future<void> fetchCourts() async {
    isLoading.value = true;
    try {
      courts.assignAll([
        CourtModel(
          id: 'court_1',
          clubId: 'club_1',
          clubName: 'Smash Arena Sports Club',
          name: 'Football Turf 1',
          surfaceType: 'Artificial Turf',
          basePricePerHour: 1200.0,
          status: 'AVAILABLE',
          city: 'Raipur',
          address: 'VIP Road',
        ),
        CourtModel(
          id: 'court_2',
          clubId: 'club_1',
          clubName: 'Smash Arena Sports Club',
          name: 'Badminton Court A',
          surfaceType: 'Wooden',
          basePricePerHour: 600.0,
          status: 'AVAILABLE',
          city: 'Raipur',
          address: 'VIP Road',
        ),
      ]);
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> bookCourt(
      String courtId, String date, String startTime, String endTime) async {
    isLoading.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      ErrorHandler.showSuccessSnackBar(
          'Booking Confirmed', 'Turf pitch booked successfully!');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Booking Failed', e);
    } finally {
      isLoading.value = false;
    }
  }
}
