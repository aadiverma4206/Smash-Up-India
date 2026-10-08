import 'package:json_annotation/json_annotation.dart';

part 'admin_models.g.dart';

@JsonSerializable()
class AdminUserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int roleId;
  final String roleName;
  final String status; // ACTIVE, SUSPENDED
  final String createdAt;

  AdminUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.roleId,
    required this.roleName,
    required this.status,
    required this.createdAt,
  });

  factory AdminUserModel.fromJson(Map<String, dynamic> json) =>
      _$AdminUserModelFromJson(json);
  Map<String, dynamic> toJson() => _$AdminUserModelToJson(this);
}

@JsonSerializable()
class AdminDashboardModel {
  final int totalUsers;
  final int totalManagers;
  final int totalPlayers;
  final int totalClubs;
  final double totalRevenue;
  final double totalRefunds;
  final int pendingDisputes;
  final int activeRecordings;
  final int onlineCameras;

  AdminDashboardModel({
    required this.totalUsers,
    required this.totalManagers,
    required this.totalPlayers,
    required this.totalClubs,
    required this.totalRevenue,
    required this.totalRefunds,
    required this.pendingDisputes,
    required this.activeRecordings,
    required this.onlineCameras,
  });

  factory AdminDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$AdminDashboardModelFromJson(json);
  Map<String, dynamic> toJson() => _$AdminDashboardModelToJson(this);
}
