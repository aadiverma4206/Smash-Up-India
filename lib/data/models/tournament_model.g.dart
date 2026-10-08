// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tournament_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TournamentModel _$TournamentModelFromJson(Map<String, dynamic> json) =>
    TournamentModel(
      id: json['id'] as String,
      title: json['title'] as String,
      format: json['format'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      prizePool: (json['prizePool'] as num).toDouble(),
      entryFee: (json['entryFee'] as num).toDouble(),
      maxTeams: (json['maxTeams'] as num).toInt(),
      registeredTeamsCount: (json['registeredTeamsCount'] as num).toInt(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$TournamentModelToJson(TournamentModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'format': instance.format,
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'prizePool': instance.prizePool,
      'entryFee': instance.entryFee,
      'maxTeams': instance.maxTeams,
      'registeredTeamsCount': instance.registeredTeamsCount,
      'status': instance.status,
    };
