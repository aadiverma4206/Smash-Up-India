import 'package:json_annotation/json_annotation.dart';

part 'tournament_model.g.dart';

@JsonSerializable()
class TournamentModel {
  final String id;
  final String title;
  final String format; // KNOCKOUT, ROUND_ROBIN
  final String startDate;
  final String endDate;
  final double prizePool;
  final double entryFee;
  final int maxTeams;
  final int registeredTeamsCount;
  final String status; // REGISTRATION_OPEN, ONGOING, COMPLETED

  TournamentModel({
    required this.id,
    required this.title,
    required this.format,
    required this.startDate,
    required this.endDate,
    required this.prizePool,
    required this.entryFee,
    required this.maxTeams,
    required this.registeredTeamsCount,
    required this.status,
  });

  factory TournamentModel.fromJson(Map<String, dynamic> json) =>
      _$TournamentModelFromJson(json);
  Map<String, dynamic> toJson() => _$TournamentModelToJson(this);
}
