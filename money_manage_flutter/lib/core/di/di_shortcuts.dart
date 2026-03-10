import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:money_manage_flutter/export/infrastructure.dart';
import 'package:money_manage_flutter/features/category/domain/usecase/create_category_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'injection.dart';

/// Infrastructure
AnalyticFirebaseService get analyticFirebaseInf =>
    getIt<AnalyticFirebaseService>();

/// Local Storage
SharedPreferences get prefs => getIt<SharedPreferences>();
FlutterSecureStorage get secureStorage => getIt<FlutterSecureStorage>();

/// Use Case
//Category
