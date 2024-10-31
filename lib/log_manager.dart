import 'package:flutter/foundation.dart';
import 'package:stack_trace/stack_trace.dart';

import 'analytics/analytics_service_interface.dart';
import 'analytics/services/default_analytics_service.dart';
import 'crashlog/crashlog_service_interface.dart';
import 'crashlog/services/default_crash_reporting_service.dart';
import 'log/log_info.dart';

void outputLog(LogInfo log, String message) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(message).forEach((match) => print(match.group(0)));
}

class LogManager {
  bool _initialized = false;
  Future<void> Function(LogInfo val)? _onLog;
  bool _saveToLocal = false;
  late String _logFormat;

  static late final void Function(LogInfo log, String message) _output;

  AnalyticsServiceInterface analytics = DefaultAnalyticsService();
  CrashlogServiceInterface crashlog = DefaultCrashlogService();

  Future<void> init({
    bool saveToLocal = false,
    String? logFormat,
    AnalyticsServiceInterface? analyticsService,
    CrashlogServiceInterface? crashlogService,
    Future<void> Function(LogInfo val)? onLog,
    void Function(LogInfo log, String message)? output,
  }) async {
    if (_initialized) return;

    _output = output ?? outputLog;

    _saveToLocal = saveToLocal;
    _logFormat = logFormat ?? "[{DATE_TIME}] [{LOG_TYPE}] [{CLASS_NAME}] [{METHOD_NAME}]: {MESSAGE} {STACK_TRACE}";

    if (analyticsService != null) {
      analytics = analyticsService;
    }

    if (crashlogService != null) {
      crashlog = crashlogService;
    }

    _onLog = onLog;

    _initialized = true;
  }

  void d(Object message) => _log(EnumLogType.debug, message);
  void i(Object message) => _log(EnumLogType.info, message);
  void w(Object message) => _log(EnumLogType.warning, message);

  void e(dynamic e, StackTrace? stack, {String? reason, bool fatal = false}) {
    _log(
      EnumLogType.error,
      e.toString(),
      reason: reason,
      stackTrace: stack,
      error: e,
      fatal: fatal,
    );
  }

  Future<void> _log(
    EnumLogType logType,
    Object message, {
    StackTrace? stackTrace,
    dynamic error,
    String? reason,
    bool fatal = false,
  }) async {
    final logInfo = LogInfo(
      logType: logType,
      message: message.toString(),
    )
      ..stackTrace = stackTrace
      ..reason = reason
      ..errorString = error?.toString()
      ..stacktraceString = stackTrace != null ? Trace.from(stackTrace).terse.toString() : null;

    _setClassAndMethodName(logInfo);

    final formattedLog = _formatLog(logInfo);

    if (_onLog != null) {
      await _onLog!(logInfo);
    }

    _output(logInfo, formattedLog);

    switch (logInfo.logType) {
      case EnumLogType.error:
      case EnumLogType.fatal:
        crashlog.recordError(
          logInfo.message,
          logInfo.stackTrace,
          fatal: logInfo.logType == EnumLogType.fatal,
          reason: logInfo.reason,
        );

      default:
        crashlog.log(
          "INFO (${logInfo.className} [${logInfo.methodName}]):  ${logInfo.message ?? ""}",
        );
    }

    if (_saveToLocal) {
      _saveLogToLocal(formattedLog);
    }
  }

  String _formatLog(LogInfo logInfo) {
    var log = _logFormat
        .replaceAll("{DATE_TIME}", logInfo.dateTime.toString())
        .replaceAll("{LOG_TYPE}", coloredLogType(logInfo.logType!))
        .replaceAll("{CLASS_NAME}", logInfo.className ?? "")
        .replaceAll("{METHOD_NAME}", logInfo.methodName ?? "");

    String message = coloredMessage(logInfo.message ?? "");

    log = log.replaceAll("{MESSAGE}", isError(logInfo.logType!) ? '\n$message' : message);

    var stacktraceString = "";

    if (logInfo.stacktraceString != null) {
      stacktraceString += '\n';
      stacktraceString += _getColorRed(
              '• ${logInfo.logType == EnumLogType.fatal ? 'Fatal ' : ''}Error${(logInfo.reason != null) ? ': ${logInfo.reason}' : ''}') +
          ('\n');
      stacktraceString += '${logInfo.stacktraceString}';
    }

    log = log.replaceAll("{STACK_TRACE}", stacktraceString);

    return log;
  }

  void _saveLogToLocal(String formattedLog) {
    // Lógica para salvar o log em arquivo local ou outro destino
  }

  void _setClassAndMethodName(LogInfo log) {
    try {
      // Captura o frame relevante (excluindo os frames do próprio log)
      final frames = Trace.current(4).frames; // Ignora os primeiros 3 frames
      final frame = frames.first;

      // Atualiza a classe e o método com base no frame atual
      final memberParts = frame.member?.split(".");
      if (memberParts != null && memberParts.length >= 2) {
        log.className = memberParts[0]; // Nome da classe
        log.methodName = memberParts[1]; // Nome do método
      } else if (memberParts != null && memberParts.length == 1) {
        log.className = 'UnknownClass'; // Caso não tenha classe
        log.methodName = memberParts[0]; // Nome da função
      } else {
        log.className = 'UnknownClass';
        log.methodName = 'UnknownMethod';
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error extracting class and method name: $e');
      }
      log.className = 'UnknownClass';
      log.methodName = 'UnknownMethod';
    }
  }

  bool isError(EnumLogType logType) {
    return logType == EnumLogType.error || logType == EnumLogType.fatal;
  }

  coloredMessage(String message) {
    return _getColorBlue(message);
  }

  coloredLogType(EnumLogType logType) {
    var name = logType.name.toUpperCase();
    switch (logType) {
      case EnumLogType.error:
        return _getColorRed(name);
      case EnumLogType.warning:
        return _getColorYellow(name);
      case EnumLogType.info:
        return _getColorGreen(name);
      default:
        return name;
    }
  }

  _getColorRed(String text) {
    if (!kDebugMode) return text;
    return "\x1B[38;5;9m$text\x1B[0m";
  }

  _getColorYellow(String text) {
    if (!kDebugMode) return text;
    return "\x1B[38;5;11m$text\x1B[0m";
  }

  _getColorGreen(String text) {
    if (!kDebugMode) return text;
    return "\x1B[38;5;10m$text\x1B[0m";
  }

  _getColorCyan(String text) {
    if (!kDebugMode) return text;
    return "\x1B[38;5;14m$text\x1B[0m";
  }

  _getColorBlue(String? text) {
    if (text == null) return "";
    if (!kDebugMode) return text;
    return "\x1B[38;5;12m$text\x1B[0m";
  }
}
