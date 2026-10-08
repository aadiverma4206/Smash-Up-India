import 'package:json_annotation/json_annotation.dart';
import 'user_model.dart';

part 'login_response_model.g.dart';

@JsonSerializable()
class LoginResponseModel {
  final UserModel user;
  final String accessToken;
  final String refreshToken;
  final int expiresInSeconds;

  LoginResponseModel({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
    required this.expiresInSeconds,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$LoginResponseModelToJson(this);
}
