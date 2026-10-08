import 'package:json_annotation/json_annotation.dart';

part 'session_model.g.dart';

@JsonSerializable()
class SessionModel {
  final String id;
  final String? deviceInfo;
  final String? ipAddress;
  final String createdAt;
  final String expiresAt;

  SessionModel({
    required this.id,
    this.deviceInfo,
    this.ipAddress,
    required this.createdAt,
    required this.expiresAt,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) =>
      _$SessionModelFromJson(json);
  Map<String, dynamic> toJson() => _$SessionModelToJson(this);
}
