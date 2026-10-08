// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admin_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdminUserModel _$AdminUserModelFromJson(Map<String, dynamic> json) =>
    AdminUserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      roleId: (json['roleId'] as num).toInt(),
      roleName: json['roleName'] as String,
      status: json['status'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$AdminUserModelToJson(AdminUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'phone': instance.phone,
      'roleId': instance.roleId,
      'roleName': instance.roleName,
      'status': instance.status,
      'createdAt': instance.createdAt,
    };

AdminDashboardModel _$AdminDashboardModelFromJson(Map<String, dynamic> json) =>
    AdminDashboardModel(
      totalUsers: (json['totalUsers'] as num).toInt(),
      totalManagers: (json['totalManagers'] as num).toInt(),
      totalPlayers: (json['totalPlayers'] as num).toInt(),
      totalClubs: (json['totalClubs'] as num).toInt(),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalRefunds: (json['totalRefunds'] as num).toDouble(),
      pendingDisputes: (json['pendingDisputes'] as num).toInt(),
      activeRecordings: (json['activeRecordings'] as num).toInt(),
      onlineCameras: (json['onlineCameras'] as num).toInt(),
    );

Map<String, dynamic> _$AdminDashboardModelToJson(
        AdminDashboardModel instance) =>
    <String, dynamic>{
      'totalUsers': instance.totalUsers,
      'totalManagers': instance.totalManagers,
      'totalPlayers': instance.totalPlayers,
      'totalClubs': instance.totalClubs,
      'totalRevenue': instance.totalRevenue,
      'totalRefunds': instance.totalRefunds,
      'pendingDisputes': instance.pendingDisputes,
      'activeRecordings': instance.activeRecordings,
      'onlineCameras': instance.onlineCameras,
    };
