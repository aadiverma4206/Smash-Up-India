// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'booking_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingModel _$BookingModelFromJson(Map<String, dynamic> json) => BookingModel(
      id: json['id'] as String,
      courtId: json['courtId'] as String,
      courtName: json['courtName'] as String,
      clubName: json['clubName'] as String,
      bookingDate: json['bookingDate'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$BookingModelToJson(BookingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'courtId': instance.courtId,
      'courtName': instance.courtName,
      'clubName': instance.clubName,
      'bookingDate': instance.bookingDate,
      'startTime': instance.startTime,
      'endTime': instance.endTime,
      'totalAmount': instance.totalAmount,
      'status': instance.status,
    };
