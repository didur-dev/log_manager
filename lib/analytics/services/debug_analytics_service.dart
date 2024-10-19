import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

import '../analytics_service_interface.dart';

/// Analytics service for debugging, outputs all events to the system log, if [enabled].
///
/// Enabled by default for debug mode ([kDebugMode]).
class DebugAnalyticsService extends AnalyticsServiceInterface {
  bool _enabled = false;

  /// Creates an analytics service object for debugging,
  /// outputs all events to the system log, if [enabled].
  ///
  /// Enabled by default for debug mode ([kDebugMode]).
  DebugAnalyticsService([this._enabled = kDebugMode]);

  static const _serviceName = 'Analytics';

  @override
  Future<void> logEvent({required String name, Map<String, Object>? parameters}) async {
    if (_enabled) {
      developer.log(
        '• Event: $name${(parameters != null) ? ': $parameters' : ''}',
        name: _serviceName,
        level: 1,
      );
    }
  }

  @override
  Future<void> resetAnalyticsData() async {
    // Do nothing
  }

  @override
  Future<void> routeStart({required String name, String? screenClass, String? namePrevious}) async {
    if (_enabled) {
      developer.log(
        '• Enter route: $name${(screenClass != null) ? ' ($screenClass)' : ''}${(namePrevious != null) ? ' from $namePrevious' : ''}',
        name: _serviceName,
        level: 1,
      );
    }
  }

  @override
  Future<void> routeEnd({required String name}) async {
    if (_enabled) {
      developer.log(
        '• Exit route: $name',
        name: _serviceName,
        level: 1,
      );
    }
  }

  @override
  Future<void> setUserId(String? id) async {
    if (_enabled) {
      developer.log(
        '• Set User Id: "$id"',
        name: _serviceName,
        level: 1,
      );
    }
  }

  @override
  Future<void> setUserProperty({required String name, required String? value}) async {
    if (_enabled) {
      developer.log(
        '• Set User Property: $name="$value"',
        name: _serviceName,
      );
    }
  }

  /// If true, output all events to the system log.
  @override
  bool get isEnabled => _enabled;

  @override
  Future<void> setEnabled(bool enabled) async => _enabled = enabled;
}
