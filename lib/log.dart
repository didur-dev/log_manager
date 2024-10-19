import 'analytics/analytics_service_interface.dart';
import 'crashlog/crashlog_service_interface.dart';
import 'log/log_info.dart';
import 'log_manager.dart';

export 'navigator/log_navigator_observer.dart';

export 'analytics/analytics_service_interface.dart';
export 'analytics/services/debug_analytics_service.dart';
export 'analytics/services/analytics_service_group.dart';
export 'analytics/services/firebase_analytics_service.dart';

export 'crashlog/crashlog_service_interface.dart';
export 'crashlog/services/debug_crashlog_service.dart';
export 'crashlog/services/crashlog_service_group.dart';
export 'crashlog/services/firebase_crashlog_service.dart';

class Log {
  static bool _initialized = false;
  static final Log _instance = Log._internal();
  static final LogManager _logManager = LogManager();

  static AnalyticsServiceInterface get analytics => _logManager.analytics;
  static CrashlogServiceInterface get crashlog => _logManager.crashlog;

  factory Log() {
    return _instance;
  }

  Log._internal();

  static Future<void> init({
    bool saveToLocal = false,
    String? logFormat,
    AnalyticsServiceInterface? analyticsService,
    CrashlogServiceInterface? crashlogService,
    Future<void> Function(LogInfo logInfo)? onLog,
    void Function(LogInfo log, String message)? output,
  }) async {
    if (_initialized) return;

    await _logManager.init(
      saveToLocal: saveToLocal,
      logFormat: logFormat,
      analyticsService: analyticsService,
      crashlogService: crashlogService,
      onLog: onLog,
      output: output,
    );

    _initialized = true;
  }

  static void _ensureInitialized() {
    if (!_initialized) {
      init();
    }
  }

  static void d(Object message) {
    _ensureInitialized();
    _logManager.d(message);
  }

  static void i(Object message) {
    _ensureInitialized();
    _logManager.i(message);
  }

  static void w(Object message) {
    _ensureInitialized();
    _logManager.w(message);
  }

  static void e(dynamic e, stack, {String? reason, bool fatal = false}) {
    _ensureInitialized();
    _logManager.e(e, stack, reason: reason, fatal: fatal);
  }
}
