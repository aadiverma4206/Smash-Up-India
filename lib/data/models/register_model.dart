import 'package:json_annotation/json_annotation.dart';

part 'register_model.g.dart';

@JsonSerializable()
class RegisterSendOtpRequestModel {
  final String name;
  final String email;
  final String phone;
  final String city;

  RegisterSendOtpRequestModel({
    required this.name,
    required this.email,
    required this.phone,
    this.city = 'Raipur',
  });

  factory RegisterSendOtpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterSendOtpRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterSendOtpRequestModelToJson(this);
}

@JsonSerializable()
class RegisterVerifyOtpRequestModel {
  final String email;
  final String phone;
  final String emailOtp;

  RegisterVerifyOtpRequestModel({
    required this.email,
    required this.phone,
    required this.emailOtp,
  });

  factory RegisterVerifyOtpRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterVerifyOtpRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterVerifyOtpRequestModelToJson(this);
}

@JsonSerializable()
class RegisterPlayerRequestModel {
  final String name;
  final String email;
  final String phone;
  final String password;
  final String city;
  final String verificationToken;

  RegisterPlayerRequestModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    this.city = 'Raipur',
    required this.verificationToken,
  });

  factory RegisterPlayerRequestModel.fromJson(Map<String, dynamic> json) =>
      _$RegisterPlayerRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$RegisterPlayerRequestModelToJson(this);
}
