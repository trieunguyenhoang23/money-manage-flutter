import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_manage_flutter/export/infrastructure.dart';
import 'package:money_manage_flutter/infrastructure/file/i_file_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'injection.dart';

/// Infrastructure
AnalyticFirebaseService get analyticFirebaseInf =>
    getIt<AnalyticFirebaseService>();

IFileService get fileService =>
    getIt<IFileService>();

/// Local Storage
SharedPreferences get prefs => getIt<SharedPreferences>();
FlutterSecureStorage get secureStorage => getIt<FlutterSecureStorage>();


