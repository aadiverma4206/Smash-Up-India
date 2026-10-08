import 'package:json_annotation/json_annotation.dart';

part 'court_model.g.dart';

double _parseDouble(dynamic value, [double defaultValue = 0.0]) {
  if (value == null) return defaultValue;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? defaultValue;
  return defaultValue;
}

class ClubModel {
  final String id;
  final String name;
  final String city;
  final String address;

  ClubModel({
    required this.id,
    required this.name,
    required this.city,
    required this.address,
  });

  factory ClubModel.fromJson(Map<String, dynamic> json) {
    return ClubModel(
      id: (json['id'] ?? json['club_id'] ?? '').toString(),
      name: (json['name'] ?? json['club_name'] ?? 'All Stars Turf').toString(),
      city: (json['city'] ?? 'Raipur').toString(),
      address: (json['address'] ?? 'VIP Road, Raipur').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'city': city,
        'address': address,
      };
}

@JsonSerializable(createFactory: false)
class CourtModel {
  final String id;
  final String clubId;
  final String clubName;
  final String name;
  final String surfaceType;
  final double basePricePerHour;
  final String status;
  final String city;
  final String address;

  CourtModel({
    required this.id,
    required this.clubId,
    required this.clubName,
    required this.name,
    required this.surfaceType,
    required this.basePricePerHour,
    required this.status,
    required this.city,
    required this.address,
  });

  factory CourtModel.fromJson(Map<String, dynamic> json) {
    return CourtModel(
      id: (json['id'] ?? json['court_id'] ?? '').toString(),
      clubId: (json['clubId'] ?? json['club_id'] ?? '').toString(),
      clubName:
          (json['clubName'] ?? json['club_name'] ?? 'Arena Turf').toString(),
      name: (json['name'] ?? json['court_name'] ?? 'Court 1').toString(),
      surfaceType:
          (json['surfaceType'] ?? json['surface'] ?? '3G Turf').toString(),
      basePricePerHour: _parseDouble(
          json['basePricePerHour'] ??
              json['base_price'] ??
              json['base_price_per_hour'],
          1200.0),
      status: (json['status'] ?? 'AVAILABLE').toString(),
      city: (json['city'] ?? 'Raipur').toString(),
      address: (json['address'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => _$CourtModelToJson(this);
}
