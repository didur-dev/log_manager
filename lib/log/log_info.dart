import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

import 'log_type.dart';
import 'log_type_group.dart';

export 'log_type.dart';
export 'log_type_group.dart';

part 'log_info.g.dart';

@JsonSerializable()
class LogInfo {
  LogInfo({this.logType, this.message}) {
    dateTime = DateTime.now();
    timeZone = dateTime!.timeZoneName;
  }

  int? launchIndex;
  int? errorIndex;
  String? className;
  String? methodName;
  String? message;
  DateTime? dateTime;
  String? timeZone;

  EnumLogType? logType;
  String? reason;
  String? errorString;
  String? stacktraceString;
  String? version;
  EnumLogTypeGroup? logTypeGroup;

  @JsonKey(includeFromJson: false, includeToJson: false)
  StackTrace? stackTrace;

  factory LogInfo.fromJson(Map<String, dynamic> json) => _$LogInfoFromJson(json);

  Map<String, dynamic> toJson() => _$LogInfoToJson(this);

  @override
  String toString() {
    String errorStr = (errorString != null && errorString != "") ? "\n-->ERROR-DETAIL: $errorString" : "";
    String stacktraceStr =
        (stacktraceString != null && stacktraceString != "") ? "\n-->STACK-TRACE: $stacktraceString" : "";
    var timeString = getDateTimeForLog(dateTime!);

    return "[${logType?.name.toUpperCase()}] [$version] [$timeString][$timeZone]  [$className]  [$methodName]  $message  $errorStr  $stacktraceStr";
  }

  getDateTimeForLog(DateTime dateTime) {
    var customFormat = DateFormat("yyyy-MM-ddTHH:mm:ss.SSS");
    String dateString = customFormat.format(dateTime);
    return dateString;
  }
}
