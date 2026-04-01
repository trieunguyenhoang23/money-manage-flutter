import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:isar_community/isar.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../export/core_external.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/category/data/model/local/category_local_model.dart';
import '../../features/main_features/profile/data/model/local/user_local_model.dart';
import '../../features/main_features/transactions/data/model/local/transaction_local_model.dart';
import '../network/auth_interceptor.dart';

@module
abstract class ModuleDI {
  @preResolve // Needed because SharedPreferences.getInstance() is async
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  FlutterSecureStorage get secureStorage => const FlutterSecureStorage();

  @Named(dioNoCache)
  @lazySingleton
  Dio dioNoCacheInstance(AuthInterceptor authInterceptor) {
    final dio = Dio(BaseOptions(baseUrl: APIConstants.bareUrl));
    dio.interceptors.addAll([
      authInterceptor,
      LogInterceptor(responseBody: true),
    ]);
    return dio;
  }

  @Named(dioWithCache)
  @preResolve
  @lazySingleton
  Future<Dio> dioWithCacheInstance(AuthInterceptor authInterceptor) async {
    final dio = Dio(BaseOptions(baseUrl: APIConstants.bareUrl));

    final dir = await getTemporaryDirectory();
    final cacheStore = HiveCacheStore(dir.path);

    final cacheOptions = CacheOptions(
      store: cacheStore,
      policy: CachePolicy.refreshForceCache,
      maxStale: const Duration(days: 1),
      hitCacheOnErrorExcept: [401, 403],
    );

    dio.interceptors.addAll([
      authInterceptor,
      DioCacheInterceptor(options: cacheOptions),
    ]);

    return dio;
  }

  @preResolve
  Future<Isar> get isar async {
    final dir = await getApplicationDocumentsDirectory();

    // Check is default db opened
    // If opened (from other Isolate), Isar.getInstance() will return that isolate
    final existingIsar = Isar.getInstance();
    if (existingIsar != null && existingIsar.isOpen) {
      return existingIsar;
    }

    final schemas = [
      CategoryLocalModelSchema,
      UserLocalModelSchema,
      TransactionLocalModelSchema,
    ];

    return await Isar.open(schemas, directory: dir.path, inspector: kDebugMode);
  }

  @lazySingleton
  ImagePicker get imagePicker => ImagePicker();

  @lazySingleton
  Connectivity get connectivity => Connectivity();

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
