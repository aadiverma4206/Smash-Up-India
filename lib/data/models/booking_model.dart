import 'package:json_annotation/json_annotation.dart';

part 'booking_model.g.dart';

@JsonSerializable()
class BookingModel {
  final String id;
  final String courtId;
  final String courtName;
  final String clubName;
  final String bookingDate;
  final String startTime;
  final String endTime;
  final double totalAmount;
  final String status; // CONFIRMED, CANCELLED, COMPLETED

  BookingModel({
    required this.id,
    required this.courtId,
    required this.courtName,
    required this.clubName,
    required this.bookingDate,
    required this.startTime,
    required this.endTime,
    required this.totalAmount,
    required this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) =>
      _$BookingModelFromJson(json);
  Map<String, dynamic> toJson() => _$BookingModelToJson(this);
}
