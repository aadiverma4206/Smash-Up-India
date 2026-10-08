// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manager_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ManagerClubModel _$ManagerClubModelFromJson(Map<String, dynamic> json) =>
    ManagerClubModel(
      id: json['id'] as String,
      name: json['name'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
      status: json['status'] as String,
    );

Map<String, dynamic> _$ManagerClubModelToJson(ManagerClubModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'city': instance.city,
      'address': instance.address,
      'status': instance.status,
    };

ManagerDashboardModel _$ManagerDashboardModelFromJson(
        Map<String, dynamic> json) =>
    ManagerDashboardModel(
      club: ManagerClubModel.fromJson(json['club'] as Map<String, dynamic>),
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalBookings: (json['totalBookings'] as num).toInt(),
      activeMatches: (json['activeMatches'] as num).toInt(),
      occupancyRatePercentage:
          (json['occupancyRatePercentage'] as num).toDouble(),
      onlineCctvCount: (json['onlineCctvCount'] as num).toInt(),
    );

Map<String, dynamic> _$ManagerDashboardModelToJson(
        ManagerDashboardModel instance) =>
    <String, dynamic>{
      'club': instance.club,
      'totalRevenue': instance.totalRevenue,
      'totalBookings': instance.totalBookings,
      'activeMatches': instance.activeMatches,
      'occupancyRatePercentage': instance.occupancyRatePercentage,
      'onlineCctvCount': instance.onlineCctvCount,
    };
