double _parseDouble(dynamic value, [double defaultValue = 0.0]) {
  if (value == null) return defaultValue;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value) ?? defaultValue;
  return defaultValue;
}

int _parseInt(dynamic value, [int defaultValue = 0]) {
  if (value == null) return defaultValue;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? defaultValue;
  return defaultValue;
}

class SlotRequestModel {
  final String id;
  final String gameId;
  final String userId;
  final String? playerName;
  final String? playerImage;
  final String? playerPosition;
  final String? skillLevel;
  final int ovr;
  final int elo;
  final String? preferredFoot;
  final String position; // Requested position
  final String status; // PENDING, APPROVED, REJECTED, WAITLISTED, CANCELLED
  final String? rejectionReason;
  final String paymentStatus;
  final double entryFee;
  final String? gameTitle;
  final String? clubName;
  final String? courtName;
  final String? matchDate;
  final String? startTime;
  final String? endTime;
  final String? format;
  final int? currentRosterCount;
  final int? maxPlayers;
  final String createdAt;

  SlotRequestModel({
    required this.id,
    required this.gameId,
    required this.userId,
    this.playerName,
    this.playerImage,
    this.playerPosition,
    this.skillLevel,
    this.ovr = 75,
    this.elo = 1200,
    this.preferredFoot,
    required this.position,
    required this.status,
    this.rejectionReason,
    this.paymentStatus = 'PAID',
    this.entryFee = 0.0,
    this.gameTitle,
    this.clubName,
    this.courtName,
    this.matchDate,
    this.startTime,
    this.endTime,
    this.format,
    this.currentRosterCount,
    this.maxPlayers,
    required this.createdAt,
  });

  factory SlotRequestModel.fromJson(Map<String, dynamic> json) {
    return SlotRequestModel(
      id: (json['id'] ?? json['request_id'] ?? '').toString(),
      gameId: (json['gameId'] ?? json['game_id'] ?? '').toString(),
      userId: (json['userId'] ?? json['user_id'] ?? '').toString(),
      playerName:
          json['playerName']?.toString() ?? json['player_name']?.toString(),
      playerImage: json['playerImage']?.toString() ??
          json['player_image']?.toString() ??
          json['profile_image_url']?.toString(),
      playerPosition: json['playerPosition']?.toString() ??
          json['player_position']?.toString(),
      skillLevel:
          json['skillLevel']?.toString() ?? json['skill_level']?.toString(),
      ovr: _parseInt(json['ovr'] ?? json['ovr_rating'], 75),
      elo: _parseInt(json['elo'] ?? json['elo_rating'], 1200),
      preferredFoot: json['preferredFoot']?.toString() ??
          json['preferred_foot']?.toString(),
      position: (json['position'] ?? 'MID').toString(),
      status: (json['status'] ?? 'PENDING').toString(),
      rejectionReason: json['rejectionReason']?.toString() ??
          json['rejection_reason']?.toString(),
      paymentStatus: (json['paymentStatus'] ?? json['payment_status'] ?? 'PAID')
          .toString(),
      entryFee: _parseDouble(json['entryFee'] ?? json['entry_fee'], 0.0),
      gameTitle:
          json['gameTitle']?.toString() ?? json['game_title']?.toString(),
      clubName: json['clubName']?.toString() ?? json['club_name']?.toString(),
      courtName:
          json['courtName']?.toString() ?? json['court_name']?.toString(),
      matchDate:
          json['matchDate']?.toString() ?? json['match_date']?.toString(),
      startTime:
          json['startTime']?.toString() ?? json['start_time']?.toString(),
      endTime: json['endTime']?.toString() ?? json['end_time']?.toString(),
      format: (json['format'] ?? '11v11').toString(),
      currentRosterCount: json['currentRosterCount'] != null ||
              json['current_roster_count'] != null
          ? _parseInt(
              json['currentRosterCount'] ?? json['current_roster_count'])
          : null,
      maxPlayers: json['maxPlayers'] != null || json['max_players'] != null
          ? _parseInt(json['maxPlayers'] ?? json['max_players'])
          : null,
      createdAt: (json['createdAt'] ?? json['created_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'gameId': gameId,
        'userId': userId,
        'position': position,
        'status': status,
        'rejectionReason': rejectionReason,
        'paymentStatus': paymentStatus,
        'entryFee': entryFee,
        'createdAt': createdAt,
      };
}

class GameActivityLogModel {
  final String id;
  final String gameId;
  final String? actorId;
  final String? actorName;
  final String actorRoleName;
  final String actionType;
  final String details;
  final String createdAt;

  GameActivityLogModel({
    required this.id,
    required this.gameId,
    this.actorId,
    this.actorName,
    required this.actorRoleName,
    required this.actionType,
    required this.details,
    required this.createdAt,
  });

  factory GameActivityLogModel.fromJson(Map<String, dynamic> json) {
    return GameActivityLogModel(
      id: (json['id'] ?? '').toString(),
      gameId: (json['gameId'] ?? json['game_id'] ?? '').toString(),
      actorId: json['actorId']?.toString() ?? json['actor_id']?.toString(),
      actorName:
          json['actorName']?.toString() ?? json['actor_name']?.toString(),
      actorRoleName:
          (json['actorRoleName'] ?? json['actor_role_name'] ?? 'SYSTEM')
              .toString(),
      actionType:
          (json['actionType'] ?? json['action_type'] ?? 'EVENT').toString(),
      details: (json['details'] ?? '').toString(),
      createdAt: (json['createdAt'] ?? json['created_at'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'gameId': gameId,
        'actorId': actorId,
        'actorName': actorName,
        'actorRoleName': actorRoleName,
        'actionType': actionType,
        'details': details,
        'createdAt': createdAt,
      };
}
