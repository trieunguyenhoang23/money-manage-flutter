import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticFirebaseService {
  static logEventTestFirebase(String value) => FirebaseAnalytics.instance
      .logEvent(name: "test_event", parameters: {"itemName": value});

  logEventCrashSplashScreen(String value) => FirebaseAnalytics.instance
      .logEvent(name: "error_splash_screen", parameters: {"itemName": value});
}
