// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'game_model.dart';

GameRosterPlayerModel _$GameRosterPlayerModelFromJson(
        Map<String, dynamic> json) =>
    GameRosterPlayerModel(
      userId: json['userId'] as String,
      name: json['name'] as String,
      team: json['team'] as String,
      position: json['position'] as String? ?? 'ST',
    );

Map<String, dynamic> _$GameRosterPlayerModelToJson(
        GameRosterPlayerModel instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'name': instance.name,
      'team': instance.team,
      'position': instance.position,
    };

GameModel _$GameModelFromJson(Map<String, dynamic> json) => GameModel(
      id: json['id'] as String,
      title: json['title'] as String,
      clubId: json['clubId'] as String,
      clubName: json['clubName'] as String,
      courtName: json['courtName'] as String,
      matchDate: json['matchDate'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      status: json['status'] as String,
      perPlayerFee: (json['perPlayerFee'] as num).toDouble(),
      maxPlayers: (json['maxPlayers'] as num).toInt(),
      currentPlayers: (json['currentPlayers'] as num).toInt(),
      teamAScore: (json['teamAScore'] as num?)?.toInt() ?? 0,
      teamBScore: (json['teamBScore'] as num?)?.toInt() ?? 0,
      roster: (json['roster'] as List<dynamic>?)
          ?.map(
              (e) => GameRosterPlayerModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      videoPlaybackUrl: json['videoPlaybackUrl'] as String?,
    );

Map<String, dynamic> _$GameModelToJson(GameModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'clubId': instance.clubId,
      'clubName': instance.clubName,
      'courtName': instance.courtName,
      'matchDate': instance.matchDate,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'status': instance.status,
      'format': instance.format,
      'sport': instance.sport,
      'perPlayerFee': instance.perPlayerFee,
      'maxPlayers': instance.maxPlayers,
      'currentPlayers': instance.currentPlayers,
      'teamAScore': instance.teamAScore,
      'teamBScore': instance.teamBScore,
      'roster': instance.roster,
      'videoPlaybackUrl': instance.videoPlaybackUrl,
    };
