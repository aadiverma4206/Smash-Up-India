import '../datasources/admin_remote_datasource.dart';
import '../../../data/models/admin_models.dart';

class AdminRepository {
  final AdminRemoteDataSource remoteDataSource;

  AdminRepository({required this.remoteDataSource});

  Future<AdminDashboardModel> getDashboard() async {
    return await remoteDataSource.getDashboard();
  }

  Future<List<AdminUserModel>> getUsers({String? search}) async {
    return await remoteDataSource.getUsers(search: search);
  }

  Future<void> suspendUser(String userId, String reason) async {
    return await remoteDataSource.suspendUser(userId, reason);
  }

  Future<void> unsuspendUser(String userId) async {
    return await remoteDataSource.unsuspendUser(userId);
  }

  Future<void> createManager({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String city,
  }) async {
    return await remoteDataSource.createManager(
      name: name,
      email: email,
      phone: phone,
      password: password,
      city: city,
    );
  }
}
