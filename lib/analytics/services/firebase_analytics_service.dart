import 'package:firebase_analytics/firebase_analytics.dart';

import '../analytics_service_interface.dart';

/// Implementation of the Firebase Analytics service for Log.
///
/// Used when configuring Log:
/// ```dart
/// await Firebase.initializeApp();
/// Log.init(
///   analyticsService: FirebaseAnalyticsService(),
/// );
/// ```
class FirebaseAnalyticsService extends AnalyticsServiceInterface {
  late FirebaseAnalytics analytics;

  FirebaseAnalyticsService(this.analytics);

  bool _enabled = true;

  @override
  Future<void> logEvent({required String name, Map<String, Object>? parameters}) {
    return analytics.logEvent(name: name, parameters: parameters);
  }

  @override
  Future<void> resetAnalyticsData() {
    return analytics.resetAnalyticsData();
  }

  @override
  Future<void> routeStart({required String name, String? screenClass, String? namePrevious}) {
    return analytics.logScreenView(screenName: name, screenClass: screenClass ?? 'Flutter');
  }

  @override
  Future<void> routeEnd({required String name}) async {}

  @override
  Future<void> setUserId(String? id) {
    return analytics.setUserId(id: id);
  }

  @override
  Future<void> setUserProperty({required String name, required String? value}) {
    return analytics.setUserProperty(name: name, value: value);
  }

  @override
  bool get isEnabled => _enabled;

  @override
  Future<void> setEnabled(bool enabled) {
    _enabled = enabled;
    return analytics.setAnalyticsCollectionEnabled(enabled);
  }
}
