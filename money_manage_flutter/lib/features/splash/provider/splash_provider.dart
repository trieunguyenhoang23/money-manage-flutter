import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_manage_flutter/core/constant/string_constant.dart';
import 'package:money_manage_flutter/core/di/injection.dart';
import 'package:money_manage_flutter/export/infrastructure.dart';
import 'package:money_manage_flutter/features/sync/presentation/provider/sync_manager_provider.dart';
import '../../../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:money_manage_flutter/export/ui_external.dart';

final splashProvider =
    AsyncNotifierProvider.autoDispose<SplashProvider, double>(
      SplashProvider.new,
    );

class SplashProvider extends AsyncNotifier<double> {
  @override
  FutureOr<double> build() async {
    await initialize();
    ref.read(syncManagerProvider.notifier).initSync();
    return 1;
  }

  Future<void> initialize() async {
    List<Future<void> Function()> tasks = [_initFirebase];

    if (kDebugMode) {
      String accessToken =
          await getIt<FlutterSecureStorage>().read(key: tokenKey) ?? 'Empty';
      print('============== Access Token: $accessToken ==============');
    }

    for (int i = 0; i < tasks.length; i++) {
      try {
        debugPrint('SplashInitializer - current index: $i');
        await tasks[i]().timeout(const Duration(seconds: 10));
      } catch (e) {
        String error = 'Error SplashInitializer: $e - index: $i';
        debugPrint(error);
        AnalyticFirebaseService.logEventCrashSplashScreen(error);
      }

      state = AsyncData((i + 1) / tasks.length);
    }

    state = const AsyncData(1);
    tasks.clear();
  }

  Future<void> _initFirebase() async {
    try {
      debugPrint('Firebase init start');

      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );

      debugPrint('Firebase init DONE');

      await RemoteConfigService.initFirebaseRemoteConfig();

      FlutterError.onError = (FlutterErrorDetails e) {
        FirebaseCrashlytics.instance.recordError(
          e.exception,
          e.stack,
          fatal: false,
        );
      };
    } catch (e, stack) {
      debugPrint('Firebase init ERROR: $e');
      debugPrint(stack.toString());
    }
  }
}
