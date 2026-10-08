import 'package:json_annotation/json_annotation.dart';

part 'game_model.g.dart';

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

String _parseCourtName(dynamic rawName, dynamic rawCourtId) {
  final nameStr = rawName?.toString().trim() ?? '';
  final idStr = rawCourtId?.toString().trim() ?? '';

  if (nameStr.toLowerCase().contains('court 2') ||
      idStr.contains('court_2') ||
      idStr.endsWith('2')) {
    return 'Court 2';
  }
  if (nameStr.toLowerCase().contains('court 1') ||
      idStr.contains('court_1') ||
      idStr.endsWith('1')) {
    return 'Court 1';
  }
  if (nameStr.toLowerCase().contains('pitch 1')) {
    return 'Court 1';
  }
  if (nameStr.toLowerCase().contains('pitch 2')) {
    return 'Court 2';
  }
  if (nameStr.isNotEmpty) {
    return nameStr;
  }
  return 'Court 1';
}

@JsonSerializable(createFactory: false)
class GameRosterPlayerModel {
  final String userId;
  final String name;
  final String? profileImageUrl;
  final String team; // TEAM_A, TEAM_B
  final String position;
  final int ovr;

  GameRosterPlayerModel({
    required this.userId,
    required this.name,
    this.profileImageUrl,
    required this.team,
    this.position = 'ST',
    this.ovr = 75,
  });

  factory GameRosterPlayerModel.fromJson(Map<String, dynamic> json) {
    return GameRosterPlayerModel(
      userId: (json['userId'] ?? json['user_id'] ?? '').toString(),
      name: (json['name'] ?? 'Player').toString(),
      profileImageUrl: json['profileImageUrl']?.toString() ??
          json['profile_image_url']?.toString(),
      team: (json['team'] ?? 'TEAM_A').toString(),
      position:
          (json['position'] ?? json['player_position'] ?? 'ST').toString(),
      ovr: _parseInt(json['ovr'] ?? json['ovr_rating'], 75),
    );
  }

  Map<String, dynamic> toJson() => _$GameRosterPlayerModelToJson(this);
}

@JsonSerializable(createFactory: false)
class GameModel {
  final String id;
  final String title;
  final String clubId;
  final String clubName;
  final String? courtId;
  final String courtName;
  final String matchDate;
  final String startTime;
  final String endTime;
  final String status; // OPEN_FOR_JOINING, FULL, ONGOING, COMPLETED, CANCELLED
  final String format; // 5v5, 7v7, 11v11, etc.
  final String? sport;
  final double perPlayerFee;
  final int maxPlayers;
  final int currentPlayers;
  final String skillRequirement;
  final String privacy;
  final String? creatorId;
  final String? creatorRoleName;
  final bool createdByPlayer;
  final int teamAScore;
  final int teamBScore;
  final String? winnerTeam;
  final String? userTeam;
  final String? userPosition;
  final String? description;
  final int? waitlistPosition;
  final List<GameRosterPlayerModel>? roster;
  final String? videoPlaybackUrl;

  GameModel({
    required this.id,
    required this.title,
    required this.clubId,
    required this.clubName,
    this.courtId,
    required this.courtName,
    required this.matchDate,
    required this.startTime,
    required this.endTime,
    required this.status,
    this.format = '11v11',
    this.sport,
    required this.perPlayerFee,
    required this.maxPlayers,
    required this.currentPlayers,
    this.skillRequirement = 'INTERMEDIATE',
    this.privacy = 'PUBLIC',
    this.creatorId,
    this.creatorRoleName,
    this.createdByPlayer = false,
    this.teamAScore = 0,
    this.teamBScore = 0,
    this.winnerTeam,
    this.userTeam,
    this.userPosition,
    this.description,
    this.waitlistPosition,
    this.roster,
    this.videoPlaybackUrl,
  });

  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: (json['id'] ?? json['game_id'] ?? '').toString(),
      title: (json['title'] ?? 'Football Match').toString(),
      clubId: (json['clubId'] ?? json['club_id'] ?? '').toString(),
      clubName:
          (json['clubName'] ?? json['club_name'] ?? 'Arena Turf').toString(),
      courtId: json['courtId']?.toString() ?? json['court_id']?.toString(),
      courtName: _parseCourtName(
        json['courtName'] ?? json['court_name'],
        json['courtId'] ?? json['court_id'],
      ),
      matchDate: (json['matchDate'] ?? json['match_date'] ?? '').toString(),
      startTime: (json['startTime'] ?? json['start_time'] ?? '').toString(),
      endTime: (json['endTime'] ?? json['end_time'] ?? '').toString(),
      status: (json['status'] ?? 'OPEN_FOR_JOINING').toString(),
      format: (json['format'] ?? '11v11').toString(),
      sport: json['sport']?.toString(),
      perPlayerFee: _parseDouble(
          json['perPlayerFee'] ?? json['entry_fee'] ?? json['per_player_fee'],
          200.0),
      maxPlayers: _parseInt(json['maxPlayers'] ?? json['max_players'], 22),
      currentPlayers:
          _parseInt(json['currentPlayers'] ?? json['current_players_count'], 0),
      skillRequirement: (json['skillRequirement'] ??
              json['skill_requirement'] ??
              'INTERMEDIATE')
          .toString(),
      privacy: (json['privacy'] ?? 'PUBLIC').toString(),
      creatorId:
          json['creatorId']?.toString() ?? json['creator_id']?.toString(),
      creatorRoleName: json['creatorRoleName']?.toString() ??
          json['creator_role_name']?.toString(),
      createdByPlayer:
          json['createdByPlayer'] ?? json['created_by_player'] ?? false,
      teamAScore: _parseInt(json['teamAScore'] ?? json['team_a_score'], 0),
      teamBScore: _parseInt(json['teamBScore'] ?? json['team_b_score'], 0),
      winnerTeam:
          json['winnerTeam']?.toString() ?? json['winner_team']?.toString(),
      userTeam: json['userTeam']?.toString() ?? json['user_team']?.toString(),
      userPosition:
          json['userPosition']?.toString() ?? json['user_position']?.toString(),
      description: json['description']?.toString(),
      waitlistPosition:
          json['waitlistPosition'] != null || json['waitlist_position'] != null
              ? _parseInt(json['waitlistPosition'] ?? json['waitlist_position'])
              : null,
      roster: json['roster'] != null
          ? (json['roster'] as List)
              .map((e) =>
                  GameRosterPlayerModel.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      videoPlaybackUrl: json['videoPlaybackUrl']?.toString() ??
          json['video_playback_url']?.toString(),
    );
  }

  Map<String, dynamic> toJson() => _$GameModelToJson(this);
}
