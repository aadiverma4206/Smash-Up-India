import '../../../core/network/dio_client.dart';
import '../../../data/models/admin_models.dart';

class AdminRemoteDataSource {
  final DioClient dioClient;

  AdminRemoteDataSource({required this.dioClient});

  Future<AdminDashboardModel> getDashboard() async {
    return AdminDashboardModel(
      totalUsers: 1420,
      totalManagers: 18,
      totalPlayers: 1402,
      totalClubs: 5,
      totalRevenue: 345000.0,
      totalRefunds: 4500.0,
      pendingDisputes: 2,
      activeRecordings: 12,
      onlineCameras: 18,
    );
  }

  Future<List<AdminUserModel>> getUsers({String? search}) async {
    return [
      AdminUserModel(
        id: '1',
        name: 'Aadi Verma',
        email: 'aadiverma4206@gmail.com',
        phone: '9876543210',
        roleId: 1,
        roleName: 'Admin',
        status: 'ACTIVE',
        createdAt: '2025-01-01',
      ),
      AdminUserModel(
        id: '2',
        name: 'Roshan Sharma',
        email: 'roshan12@gmail.com',
        phone: '9123456789',
        roleId: 2,
        roleName: 'Manager',
        status: 'ACTIVE',
        createdAt: '2025-01-05',
      ),
      AdminUserModel(
        id: '3',
        name: 'Rahul Player',
        email: 'player@gmail.com',
        phone: '9988776655',
        roleId: 3,
        roleName: 'Player',
        status: 'ACTIVE',
        createdAt: '2025-02-10',
      ),
    ];
  }

  Future<void> suspendUser(String userId, String reason) async {}
  Future<void> unsuspendUser(String userId) async {}
  Future<void> createManager({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String city,
  }) async {}
}
