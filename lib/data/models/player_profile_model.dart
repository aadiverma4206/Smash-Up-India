import 'package:json_annotation/json_annotation.dart';

part 'player_profile_model.g.dart';

@JsonSerializable(createFactory: false)
class PlayerProfileModel {
  final String userId;
  final String name;
  final String email;
  final String phone;
  final String city;
  final String? bio;
  final String? avatarUrl;
  final String? dateOfBirth;
  final String position; // ST, CM, CB, GK, etc.
  final String? secondaryPosition;
  final String preferredFoot; // RIGHT, LEFT, BOTH
  final String skillLevel; // AMATEUR, SEMI_PRO, PRO
  final int ovr; // Overall Rating (50 - 99)
  final int elo; // ELO Rating (e.g. 1200)
  final double walletBalance;
  final String accountStatus;

  PlayerProfileModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    this.bio,
    this.avatarUrl,
    this.dateOfBirth,
    this.position = 'ST',
    this.secondaryPosition,
    this.preferredFoot = 'RIGHT',
    this.skillLevel = 'AMATEUR',
    this.ovr = 75,
    this.elo = 1200,
    this.walletBalance = 0.0,
    this.accountStatus = 'ACTIVE',
  });

  factory PlayerProfileModel.fromJson(Map<String, dynamic> json) {
    String rawFoot =
        (json['preferredFoot'] ?? json['preferred_foot'] ?? 'RIGHT')
            .toString()
            .trim()
            .toUpperCase();
    if (rawFoot.startsWith('RIGHT')) {
      rawFoot = 'RIGHT';
    } else if (rawFoot.startsWith('LEFT')) {
      rawFoot = 'LEFT';
    } else if (rawFoot.startsWith('BOTH') || rawFoot.contains('AMBI')) {
      rawFoot = 'BOTH';
    } else if (!['RIGHT', 'LEFT', 'BOTH'].contains(rawFoot)) {
      rawFoot = 'RIGHT';
    }

    String rawPos = (json['position'] ?? 'ST').toString().trim().toUpperCase();
    const allowedPos = [
      'GK',
      'CB',
      'LB',
      'RB',
      'CDM',
      'CM',
      'CAM',
      'ST',
      'LW',
      'RW'
    ];
    if (!allowedPos.contains(rawPos)) rawPos = 'ST';

    String? rawSec = json['secondaryPosition'] ?? json['secondary_position'];
    if (rawSec != null) {
      rawSec = rawSec.toString().trim().toUpperCase();
      if (!allowedPos.contains(rawSec) && rawSec != 'NONE') rawSec = null;
    }

    String rawSkill = (json['skillLevel'] ?? json['skill_level'] ?? 'AMATEUR')
        .toString()
        .trim()
        .toUpperCase();
    if (rawSkill.contains('BEGINNER') || rawSkill.contains('AMATEUR')) {
      rawSkill = 'AMATEUR';
    } else if (rawSkill.contains('SEMI') || rawSkill.contains('INTERMEDIATE')) {
      rawSkill = 'SEMI_PRO';
    } else if (rawSkill.contains('PRO') || rawSkill.contains('ADVANCED')) {
      rawSkill = 'PRO';
    } else if (!['AMATEUR', 'SEMI_PRO', 'PRO'].contains(rawSkill)) {
      rawSkill = 'AMATEUR';
    }

    return PlayerProfileModel(
      userId: (json['userId'] ?? json['id'] ?? '') as String,
      name: (json['name'] ?? 'Player') as String,
      email: (json['email'] ?? '') as String,
      phone: (json['phone'] ?? '') as String,
      city: (json['city'] ?? 'Raipur') as String,
      bio: json['bio'] as String?,
      avatarUrl: (json['avatarUrl'] ??
          json['avatar_url'] ??
          json['profile_image_url'] ??
          json['profileImageUrl']) as String?,
      dateOfBirth: (json['dateOfBirth'] ?? json['date_of_birth']) as String?,
      position: rawPos,
      secondaryPosition: rawSec,
      preferredFoot: rawFoot,
      skillLevel: rawSkill,
      ovr: (json['ovr'] ?? json['ovr_rating'] as num?)?.toInt() ?? 75,
      elo: (json['elo'] ?? json['elo_rating'] as num?)?.toInt() ?? 1200,
      walletBalance: (json['walletBalance'] ?? json['wallet_balance'] as num?)
              ?.toDouble() ??
          0.0,
      accountStatus: (json['accountStatus'] ??
          json['account_status'] ??
          'ACTIVE') as String,
    );
  }

  Map<String, dynamic> toJson() => _$PlayerProfileModelToJson(this);
}
