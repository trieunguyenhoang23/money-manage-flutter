import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar_community/isar.dart';
import '../../export/core_external.dart';
import 'package:shared_preferences/shared_preferences.dart';


@module
abstract class ModuleDI {
  //Dependency này cần khởi tạo trước khi DI container hoàn tất setup, và nó là async.
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  // @preResolve
  // Future<Isar> get isar async {
  //   final dir = await getApplicationDocumentsDirectory();
  //   final schemas = [
  //
  //   ];
  //   return await Isar.open(
  //     schemas,
  //     directory: dir.path,
  //     inspector: kDebugMode,
  //   );
  // }

  // @lazySingleton
  // List<NotificationHandler> provideNotificationHandlers(
  //         OpenDetailWallpaperHandler openDetailWallpaperHandler) =>
  //     [openDetailWallpaperHandler];
  //
  // @lazySingleton
  // IapPlatformHandler provideIapPlatformHandler() {
  //   return Platform.isAndroid ? IapAndroidHandler() : IapIosHandler();
  // }
}
