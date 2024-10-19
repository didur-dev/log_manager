import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:log_manager/log.dart';

void main() {
  runApp(const MyApp());

  Log.init(
    saveToLocal: false,
    analyticsService: AnalyticsServiceGroup([
      DebugAnalyticsService(),
      //FirebaseAnalyticsService(FirebaseAnalytics.instance),
    ]),
    crashlogService: CrashlogServiceGroup([
      DebugCrashlogService(enabled: kDebugMode, showLogs: false, showErrors: false, showFatalErrors: true),
      //FirebaseCrashlogService(FirebaseCrashlytics.instance)
    ]),
  );

  FlutterError.onError = (FlutterErrorDetails errorDetails) {
    Log.e(
      errorDetails.exceptionAsString(),
      errorDetails.stack,
      reason: errorDetails.context?.toStringDeep(minLevel: DiagnosticLevel.info).trim(),
    );
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    Log.e(error, stack);
    return true;
  };

  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    Log.e(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
    );
  }).sendPort);
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    Log.d("Init state called");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorObservers: [
        LogNavigatorObserver(),
      ],
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: const Center(
          child: Text('Log Manager'),
        ),
      ),
    );
  }
}
