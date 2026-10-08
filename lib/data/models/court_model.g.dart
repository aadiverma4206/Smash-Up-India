// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'court_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CourtModel _$CourtModelFromJson(Map<String, dynamic> json) => CourtModel(
      id: json['id'] as String,
      clubId: json['clubId'] as String,
      clubName: json['clubName'] as String,
      name: json['name'] as String,
      surfaceType: json['surfaceType'] as String,
      basePricePerHour: (json['basePricePerHour'] as num).toDouble(),
      status: json['status'] as String,
      city: json['city'] as String,
      address: json['address'] as String,
    );

Map<String, dynamic> _$CourtModelToJson(CourtModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clubId': instance.clubId,
      'clubName': instance.clubName,
      'name': instance.name,
      'surfaceType': instance.surfaceType,
      'basePricePerHour': instance.basePricePerHour,
      'status': instance.status,
      'city': instance.city,
      'address': instance.address,
    };
