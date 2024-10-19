// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LogInfo _$LogInfoFromJson(Map<String, dynamic> json) => LogInfo(
      logType: $enumDecodeNullable(_$EnumLogTypeEnumMap, json['logType']),
      message: json['message'] as String?,
    )
      ..launchIndex = (json['launchIndex'] as num?)?.toInt()
      ..errorIndex = (json['errorIndex'] as num?)?.toInt()
      ..className = json['className'] as String?
      ..methodName = json['methodName'] as String?
      ..dateTime = json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String)
      ..timeZone = json['timeZone'] as String?
      ..reason = json['reason'] as String?
      ..errorString = json['errorString'] as String?
      ..stacktraceString = json['stacktraceString'] as String?
      ..version = json['version'] as String?
      ..logTypeGroup =
          $enumDecodeNullable(_$EnumLogTypeGroupEnumMap, json['logTypeGroup']);

Map<String, dynamic> _$LogInfoToJson(LogInfo instance) => <String, dynamic>{
      'launchIndex': instance.launchIndex,
      'errorIndex': instance.errorIndex,
      'className': instance.className,
      'methodName': instance.methodName,
      'message': instance.message,
      'dateTime': instance.dateTime?.toIso8601String(),
      'timeZone': instance.timeZone,
      'logType': _$EnumLogTypeEnumMap[instance.logType],
      'reason': instance.reason,
      'errorString': instance.errorString,
      'stacktraceString': instance.stacktraceString,
      'version': instance.version,
      'logTypeGroup': _$EnumLogTypeGroupEnumMap[instance.logTypeGroup],
    };

const _$EnumLogTypeEnumMap = {
  EnumLogType.debug: 'debug',
  EnumLogType.info: 'info',
  EnumLogType.warning: 'warning',
  EnumLogType.error: 'error',
  EnumLogType.fatal: 'fatal',
};

const _$EnumLogTypeGroupEnumMap = {
  EnumLogTypeGroup.production: 'production',
  EnumLogTypeGroup.debug: 'debug',
};
