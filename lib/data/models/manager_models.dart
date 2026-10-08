import 'package:json_annotation/json_annotation.dart';

part 'manager_models.g.dart';

@JsonSerializable()
class ManagerClubModel {
  final String id;
  final String name;
  final String city;
  final String address;
  final String status;

  ManagerClubModel({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
    required this.status,
  });

  factory ManagerClubModel.fromJson(Map<String, dynamic> json) =>
      _$ManagerClubModelFromJson(json);
  Map<String, dynamic> toJson() => _$ManagerClubModelToJson(this);
}

@JsonSerializable()
class ManagerDashboardModel {
  final ManagerClubModel club;
  final double totalRevenue;
  final int totalBookings;
  final int activeMatches;
  final double occupancyRatePercentage;
  final int onlineCctvCount;

  ManagerDashboardModel({
    required this.club,
    required this.totalRevenue,
    required this.totalBookings,
    required this.activeMatches,
    required this.occupancyRatePercentage,
    required this.onlineCctvCount,
  });

  factory ManagerDashboardModel.fromJson(Map<String, dynamic> json) =>
      _$ManagerDashboardModelFromJson(json);
  Map<String, dynamic> toJson() => _$ManagerDashboardModelToJson(this);
}
