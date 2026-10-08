import 'package:json_annotation/json_annotation.dart';

part 'login_request_model.g.dart';

@JsonSerializable(includeIfNull: false)
class LoginRequestModel {
  final String identifier;
  final String password;
  final Map<String, dynamic>? device;

  LoginRequestModel({
    required this.identifier,
    required this.password,
    this.device,
  });

  factory LoginRequestModel.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginRequestModelToJson(this);
}
