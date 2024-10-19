import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import '../crashlog_service_interface.dart';

/// Implementation of the Firebase Crashlytics service for Log.
///
/// Used when configuring Log:
/// ```dart
/// await Firebase.initializeApp();
/// Log.init(
///   crashlogService: FirebaseCrashlogService(),
/// );
/// ```
class FirebaseCrashlogService extends CrashlogServiceInterface {
  final FirebaseCrashlytics crashlytics;

  FirebaseCrashlogService(this.crashlytics);

  @override
  Future<void> log(String message) {
    message = filterLog(message);
    return crashlytics.log(removeAnsiCodes(message));
  }

  @override
  Future<void> recordError(exception, StackTrace? stackTrace, {reason, bool fatal = false}) {
    return crashlytics.recordError(exception, stackTrace, reason: reason, fatal: fatal, printDetails: false);
  }

  @override
  Future<void> setCustomKey(String key, Object value) {
    return crashlytics.setCustomKey(key, value);
  }

  @override
  Future<void> setUserId(String id) {
    return crashlytics.setUserIdentifier(id);
  }

  @override
  bool get isEnabled => crashlytics.isCrashlyticsCollectionEnabled;

  @override
  Future<void> setEnabled(bool enabled) => crashlytics.setCrashlyticsCollectionEnabled(enabled);

  String filterLog(String message) {
    if (message.contains('HttpLogInterceptor')) {
      message = message.split('\n').first;
    }

    return message;
  }

  String removeAnsiCodes(String text) {
    final ansiRegex = RegExp(r'(\x9B|\x1B\[)[0-?]*[ -\/]*[@-~]');
    return text.replaceAll(ansiRegex, '');
  }
}
