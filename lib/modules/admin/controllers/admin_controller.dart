import 'package:get/get.dart';
import '../repositories/admin_repository.dart';
import '../../../data/models/admin_models.dart';
import '../../../core/errors/error_handler.dart';
import '../../../core/utils/app_logger.dart';

class AdminController extends GetxController {
  final AdminRepository repository = Get.find<AdminRepository>();

  final Rxn<AdminDashboardModel> dashboard = Rxn<AdminDashboardModel>();
  final RxList<AdminUserModel> users = <AdminUserModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;
  final RxInt selectedNavIndex = 0.obs;

  void changeNavIndex(int index) {
    selectedNavIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    loadDashboard();
    fetchUsers();
  }

  Future<void> loadDashboard() async {
    isLoading.value = true;
    try {
      final d = await repository.getDashboard();
      dashboard.value = d;
    } catch (e) {
      AppLogger.warning('Admin dashboard load error: $e');
      ErrorHandler.showErrorSnackBar('Forbidden', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchUsers() async {
    try {
      final list = await repository.getUsers(search: searchQuery.value);
      users.assignAll(list);
    } catch (e) {
      AppLogger.warning('Failed to fetch users: $e');
    }
  }

  Future<void> suspendUser(String userId) async {
    isLoading.value = true;
    try {
      await repository.suspendUser(userId, 'Administrative Suspension');
      await fetchUsers();
      ErrorHandler.showSuccessSnackBar(
          'Account Suspended', 'User account was suspended.');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> unsuspendUser(String userId) async {
    isLoading.value = true;
    try {
      await repository.unsuspendUser(userId);
      await fetchUsers();
      ErrorHandler.showSuccessSnackBar(
          'Account Reactivated', 'User account is now ACTIVE.');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Error', e);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createManager({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String city,
  }) async {
    isLoading.value = true;
    try {
      await repository.createManager(
        name: name,
        email: email,
        phone: phone,
        password: password,
        city: city,
      );
      Get.back();
      await fetchUsers();
      ErrorHandler.showSuccessSnackBar(
          'Manager Created', 'Turf Manager account created successfully.');
    } catch (e) {
      ErrorHandler.showErrorSnackBar('Creation Error', e);
    } finally {
      isLoading.value = false;
    }
  }
}
