// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cctv_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CctvCameraModel _$CctvCameraModelFromJson(Map<String, dynamic> json) =>
    CctvCameraModel(
      id: json['id'] as String,
      clubId: json['clubId'] as String,
      courtId: json['courtId'] as String?,
      courtName: json['courtName'] as String?,
      name: json['name'] as String,
      cameraType: json['cameraType'] as String? ?? 'RTSP_DOME',
      connectionType: json['connectionType'] as String? ?? 'RTSP',
      ipAddress: json['ipAddress'] as String?,
      port: (json['port'] as num?)?.toInt() ?? 554,
      isEnabled: json['isEnabled'] as bool? ?? true,
      status: json['status'] as String? ?? 'ONLINE',
      healthStatus: json['healthStatus'] as String? ?? 'ONLINE',
      lastSeenAt: json['lastSeenAt'] as String?,
    );

Map<String, dynamic> _$CctvCameraModelToJson(CctvCameraModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'clubId': instance.clubId,
      'courtId': instance.courtId,
      'courtName': instance.courtName,
      'name': instance.name,
      'cameraType': instance.cameraType,
      'connectionType': instance.connectionType,
      'ipAddress': instance.ipAddress,
      'port': instance.port,
      'isEnabled': instance.isEnabled,
      'status': instance.status,
      'healthStatus': instance.healthStatus,
      'lastSeenAt': instance.lastSeenAt,
    };

CctvRecordingModel _$CctvRecordingModelFromJson(Map<String, dynamic> json) =>
    CctvRecordingModel(
      id: json['id'] as String,
      gameId: json['gameId'] as String,
      clubId: json['clubId'] as String,
      courtId: json['courtId'] as String?,
      cameraId: json['cameraId'] as String?,
      status: json['status'] as String,
      recordingStatus: json['recordingStatus'] as String,
      startedAt: json['startedAt'] as String,
      scheduledMatchEnd: json['scheduledMatchEnd'] as String,
      stopDeadline: json['stopDeadline'] as String,
      actualStopTime: json['actualStopTime'] as String?,
      manualStop: json['manualStop'] as bool? ?? false,
    );

Map<String, dynamic> _$CctvRecordingModelToJson(CctvRecordingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'gameId': instance.gameId,
      'clubId': instance.clubId,
      'courtId': instance.courtId,
      'cameraId': instance.cameraId,
      'status': instance.status,
      'recordingStatus': instance.recordingStatus,
      'startedAt': instance.startedAt,
      'scheduledMatchEnd': instance.scheduledMatchEnd,
      'stopDeadline': instance.stopDeadline,
      'actualStopTime': instance.actualStopTime,
      'manualStop': instance.manualStop,
    };
