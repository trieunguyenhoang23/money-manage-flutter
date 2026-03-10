import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:isar_community/isar.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../export/core_external.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/category/data/model/local/category_local_model.dart';

@module
abstract class ModuleDI {
  @preResolve // Needed because SharedPreferences.getInstance() is async
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @Named(dioNoCache)
  @lazySingleton
  Dio get dioNoCacheInstance {
    final dio = Dio(BaseOptions(baseUrl: APIConstants.bareUrl));
    dio.interceptors.add(LogInterceptor(responseBody: true));
    return dio;
  }

  @Named(dioWithCache)
  @preResolve
  @lazySingleton
  Future<Dio> dioWithCacheInstance() async {
    final dio = Dio(BaseOptions(baseUrl: APIConstants.bareUrl));

    final dir = await getTemporaryDirectory();
    final cacheStore = HiveCacheStore(dir.path);

    final cacheOptions = CacheOptions(
      store: cacheStore,
      policy: CachePolicy.refreshForceCache,
      maxStale: const Duration(days: 1),
      hitCacheOnErrorExcept: [401, 403],
    );

    dio.interceptors.add(DioCacheInterceptor(options: cacheOptions));

    return dio;
  }

  @preResolve
  Future<Isar> get isar async {
    final dir = await getApplicationDocumentsDirectory();
    final schemas = [CategoryLocalModelSchema];

    return await Isar.open(schemas, directory: dir.path, inspector: kDebugMode);
  }

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
