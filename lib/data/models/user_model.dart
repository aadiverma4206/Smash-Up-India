import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final int roleId;
  final String? roleName;
  final String status;
  final String? city;
  final String? profileImageUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.roleId,
    this.roleName,
    required this.status,
    this.city,
    this.profileImageUrl,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      roleId: json['roleId'] is int
          ? json['roleId'] as int
          : int.tryParse(json['roleId']?.toString() ?? '3') ?? 3,
      roleName: json['roleName'] as String?,
      status: json['status'] as String? ?? 'ACTIVE',
      city: json['city'] as String?,
      profileImageUrl: json['profileImageUrl'] as String? ?? json['avatar'] as String?,
    );
  }
  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
