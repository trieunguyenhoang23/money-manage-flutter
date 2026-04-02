// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:connectivity_plus/connectivity_plus.dart' as _i895;
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:image_picker/image_picker.dart' as _i183;
import 'package:injectable/injectable.dart' as _i526;
import 'package:isar_community/isar.dart' as _i214;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../../export/core.dart' as _i858;
import '../../export/infrastructure.dart' as _i989;
import '../../features/category/data/datasource/local/category_local_datasource.dart'
    as _i197;
import '../../features/category/data/datasource/remote/category_remote_datasource.dart'
    as _i702;
import '../../features/category/data/repositories/category_repository_impl.dart'
    as _i528;
import '../../features/category/domain/repositories/category_repository.dart'
    as _i869;
import '../../features/category/domain/usecase/create_category_usecase.dart'
    as _i845;
import '../../features/category/domain/usecase/edit_category_usecase.dart'
    as _i617;
import '../../features/category/domain/usecase/loading_category_usecase.dart'
    as _i1069;
import '../../features/main_features/analytics/data/datasource/local/analytics_local_datasource.dart'
    as _i773;
import '../../features/main_features/analytics/data/datasource/remote/analytics_remote_datasource.dart'
    as _i940;
import '../../features/main_features/analytics/data/repositories/analytics_repository_impl.dart'
    as _i706;
import '../../features/main_features/analytics/domain/repositories/analytics_repository.dart'
    as _i579;
import '../../features/main_features/analytics/domain/usecase/get_categories_analytics_usecase.dart'
    as _i1031;
import '../../features/main_features/analytics/domain/usecase/get_overview_balance_usecase.dart'
    as _i1011;
import '../../features/main_features/analytics/domain/usecase/get_overview_usecase.dart'
    as _i767;
import '../../features/main_features/profile/data/datasource/local/user_local_datasource.dart'
    as _i809;
import '../../features/main_features/profile/data/datasource/remote/user_remote_datasource.dart'
    as _i1026;
import '../../features/main_features/profile/data/repositories/user_repository_impl.dart'
    as _i790;
import '../../features/main_features/profile/domain/repositories/user_repository.dart'
    as _i168;
import '../../features/main_features/profile/domain/usecase/auth_usecase.dart'
    as _i429;
import '../../features/main_features/profile/domain/usecase/logout_usecase.dart'
    as _i100;
import '../../features/main_features/profile/domain/usecase/update_currency_usecase.dart'
    as _i870;
import '../../features/main_features/transactions/data/datasource/local/transactions_local_datasource.dart'
    as _i1013;
import '../../features/main_features/transactions/data/datasource/remote/transactions_remote_datasource.dart'
    as _i407;
import '../../features/main_features/transactions/data/repositories/transaction_repository_impl.dart'
    as _i716;
import '../../features/main_features/transactions/domain/repositories/transaction_repository.dart'
    as _i874;
import '../../features/main_features/transactions/domain/usecase/create_transaction_usecase.dart'
    as _i373;
import '../../features/main_features/transactions/domain/usecase/get_popular_category_usecase.dart'
    as _i168;
import '../../features/main_features/transactions/domain/usecase/loading_transaction_usecase.dart'
    as _i233;
import '../../features/main_features/transactions/domain/usecase/remove_transaction_usecase.dart'
    as _i269;
import '../../features/main_features/transactions/domain/usecase/update_transaction_usecase.dart'
    as _i947;
import '../../features/sync/data/datasource/remote/sync_remote_datasource.dart'
    as _i472;
import '../../features/sync/data/repositories/sync_repository_impl.dart'
    as _i91;
import '../../features/sync/domain/repositories/sync_repository.dart' as _i129;
import '../../features/sync/domain/usecase/sync_category_usecase.dart' as _i773;
import '../../features/sync/domain/usecase/sync_transaction_usecase.dart'
    as _i79;
import '../../infrastructure/file/file_service.dart' as _i835;
import '../../infrastructure/file/i_file_service.dart' as _i820;
import '../../infrastructure/file/img_processor.dart' as _i575;
import '../../infrastructure/network/dio_service.dart' as _i960;
import '../../infrastructure/network/network_info.dart' as _i436;
import '../../infrastructure/social_auth/apple_auth_service.dart' as _i502;
import '../../infrastructure/social_auth/google_auth_service.dart' as _i219;
import '../../infrastructure/social_auth/social_auth_factory.dart' as _i22;
import '../data/datasource/sync_lazy_loading.dart' as _i446;
import '../network/auth_interceptor.dart' as _i908;
import '../network/sync_manager.dart' as _i848;
import 'module_di.dart' as _i633;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final moduleDI = _$ModuleDI();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => moduleDI.prefs,
      preResolve: true,
    );
    await gh.factoryAsync<_i214.Isar>(() => moduleDI.isar, preResolve: true);
    gh.lazySingleton<_i558.FlutterSecureStorage>(() => moduleDI.secureStorage);
    gh.lazySingleton<_i183.ImagePicker>(() => moduleDI.imagePicker);
    gh.lazySingleton<_i895.Connectivity>(() => moduleDI.connectivity);
    gh.lazySingleton<_i575.ImageProcessor>(() => _i575.ImageProcessor());
    gh.lazySingleton<_i502.AppleAuthService>(() => _i502.AppleAuthService());
    gh.lazySingleton<_i219.GoogleAuthService>(() => _i219.GoogleAuthService());
    gh.lazySingleton<_i197.CategoryLocalDatasource>(
      () => _i197.CategoryLocalDatasource(gh<_i214.Isar>()),
    );
    gh.lazySingleton<_i773.AnalyticsLocalDatasource>(
      () => _i773.AnalyticsLocalDatasource(gh<_i214.Isar>()),
    );
    gh.lazySingleton<_i1013.TransactionsLocalDatasource>(
      () => _i1013.TransactionsLocalDatasource(gh<_i214.Isar>()),
    );
    gh.lazySingleton<_i446.SyncLazyLoading>(
      () => _i446.SyncLazyLoading(gh<_i460.SharedPreferences>()),
    );
    gh.singleton<_i820.IFileService>(
      () => _i835.FileServiceImpl(
        gh<_i183.ImagePicker>(),
        gh<_i575.ImageProcessor>(),
      ),
    );
    gh.factory<_i908.AuthInterceptor>(
      () => _i908.AuthInterceptor(gh<_i558.FlutterSecureStorage>()),
    );
    gh.lazySingleton<_i809.UserLocalDatasource>(
      () => _i809.UserLocalDatasource(
        gh<_i214.Isar>(),
        gh<_i558.FlutterSecureStorage>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    gh.lazySingleton<_i361.Dio>(
      () => moduleDI.dioNoCacheInstance(gh<_i908.AuthInterceptor>()),
      instanceName: 'dioNoCache',
    );
    gh.lazySingleton<_i436.NetworkInfo>(
      () => _i436.NetworkInfoImpl(gh<_i895.Connectivity>()),
    );
    gh.lazySingleton<_i22.SocialAuthFactory>(
      () => _i22.SocialAuthFactory(
        gh<_i219.GoogleAuthService>(),
        gh<_i502.AppleAuthService>(),
      ),
    );
    await gh.lazySingletonAsync<_i361.Dio>(
      () => moduleDI.dioWithCacheInstance(gh<_i908.AuthInterceptor>()),
      instanceName: 'dioWithCache',
      preResolve: true,
    );
    gh.lazySingleton<_i960.DioService>(
      () => _i960.DioService(
        gh<_i361.Dio>(instanceName: 'dioWithCache'),
        gh<_i361.Dio>(instanceName: 'dioNoCache'),
      ),
    );
    gh.lazySingleton<_i848.SyncManager>(
      () => _i848.SyncManager(
        gh<_i436.NetworkInfo>(),
        gh<_i809.UserLocalDatasource>(),
        gh<_i558.FlutterSecureStorage>(),
      ),
    );
    gh.lazySingleton<_i702.CategoryRemoteDatasource>(
      () => _i702.CategoryRemoteDatasource(gh<_i989.DioService>()),
    );
    gh.lazySingleton<_i940.AnalyticsRemoteDatasource>(
      () => _i940.AnalyticsRemoteDatasource(gh<_i989.DioService>()),
    );
    gh.lazySingleton<_i1026.UserRemoteDatasource>(
      () => _i1026.UserRemoteDatasource(gh<_i989.DioService>()),
    );
    gh.lazySingleton<_i407.TransactionsRemoteDatasource>(
      () => _i407.TransactionsRemoteDatasource(gh<_i989.DioService>()),
    );
    gh.lazySingleton<_i472.SyncRemoteDatasource>(
      () => _i472.SyncRemoteDatasource(gh<_i989.DioService>()),
    );
    gh.lazySingleton<_i869.CategoryRepository>(
      () => _i528.CategoryRepositoryImpl(
        gh<_i702.CategoryRemoteDatasource>(),
        gh<_i197.CategoryLocalDatasource>(),
        gh<_i858.SyncManager>(),
        gh<_i446.SyncLazyLoading>(),
      ),
    );
    gh.lazySingleton<_i579.AnalyticsRepository>(
      () => _i706.AnalyticsRepositoryImpl(
        gh<_i773.AnalyticsLocalDatasource>(),
        gh<_i940.AnalyticsRemoteDatasource>(),
        gh<_i858.SyncManager>(),
        gh<_i858.SyncLazyLoading>(),
        gh<_i809.UserLocalDatasource>(),
      ),
    );
    gh.lazySingleton<_i845.CreateCategoryUseCase>(
      () => _i845.CreateCategoryUseCase(gh<_i869.CategoryRepository>()),
    );
    gh.lazySingleton<_i617.EditCategoryUseCase>(
      () => _i617.EditCategoryUseCase(gh<_i869.CategoryRepository>()),
    );
    gh.lazySingleton<_i874.TransactionRepository>(
      () => _i716.TransactionRepositoryImpl(
        gh<_i407.TransactionsRemoteDatasource>(),
        gh<_i1013.TransactionsLocalDatasource>(),
        gh<_i858.SyncManager>(),
        gh<_i858.SyncLazyLoading>(),
        gh<_i197.CategoryLocalDatasource>(),
      ),
    );
    gh.lazySingleton<_i168.UserRepository>(
      () => _i790.UserRepositoryImpl(
        gh<_i809.UserLocalDatasource>(),
        gh<_i1026.UserRemoteDatasource>(),
        gh<_i989.SocialAuthFactory>(),
        gh<_i848.SyncManager>(),
      ),
    );
    gh.lazySingleton<_i1011.GetOverviewBalanceUseCase>(
      () => _i1011.GetOverviewBalanceUseCase(gh<_i579.AnalyticsRepository>()),
    );
    gh.lazySingleton<_i1031.GetCategoriesAnalyticsUseCase>(
      () =>
          _i1031.GetCategoriesAnalyticsUseCase(gh<_i579.AnalyticsRepository>()),
    );
    gh.lazySingleton<_i767.GetOverviewUseCase>(
      () => _i767.GetOverviewUseCase(gh<_i579.AnalyticsRepository>()),
    );
    gh.lazySingleton<_i129.SyncRepository>(
      () => _i91.SyncRepositoryImpl(
        gh<_i197.CategoryLocalDatasource>(),
        gh<_i1013.TransactionsLocalDatasource>(),
        gh<_i472.SyncRemoteDatasource>(),
        gh<_i848.SyncManager>(),
      ),
    );
    gh.lazySingleton<_i429.AuthUseCase>(
      () => _i429.AuthUseCase(gh<_i168.UserRepository>()),
    );
    gh.lazySingleton<_i870.UpdateCurrencyUseCase>(
      () => _i870.UpdateCurrencyUseCase(gh<_i168.UserRepository>()),
    );
    gh.lazySingleton<_i1069.LoadingCategoryUseCase>(
      () => _i1069.LoadingCategoryUseCase(gh<_i869.CategoryRepository>()),
    );
    gh.lazySingleton<_i373.CreateTransactionUseCase>(
      () => _i373.CreateTransactionUseCase(gh<_i874.TransactionRepository>()),
    );
    gh.lazySingleton<_i168.GetPopularCategoryUseCase>(
      () => _i168.GetPopularCategoryUseCase(gh<_i874.TransactionRepository>()),
    );
    gh.lazySingleton<_i233.LoadingTransactionUseCase>(
      () => _i233.LoadingTransactionUseCase(gh<_i874.TransactionRepository>()),
    );
    gh.lazySingleton<_i269.RemoveTransactionUseCase>(
      () => _i269.RemoveTransactionUseCase(gh<_i874.TransactionRepository>()),
    );
    gh.lazySingleton<_i947.UpdateTransactionUseCase>(
      () => _i947.UpdateTransactionUseCase(gh<_i874.TransactionRepository>()),
    );
    gh.lazySingleton<_i79.SyncTransactionUseCase>(
      () => _i79.SyncTransactionUseCase(gh<_i129.SyncRepository>()),
    );
    gh.factory<_i773.SyncCateUseCase>(
      () => _i773.SyncCateUseCase(gh<_i129.SyncRepository>()),
    );
    gh.lazySingleton<_i100.LogoutUseCase>(
      () => _i100.LogoutUseCase(
        gh<_i168.UserRepository>(),
        gh<_i869.CategoryRepository>(),
        gh<_i874.TransactionRepository>(),
        gh<_i446.SyncLazyLoading>(),
        gh<_i558.FlutterSecureStorage>(),
        gh<_i460.SharedPreferences>(),
      ),
    );
    return this;
  }
}

class _$ModuleDI extends _i633.ModuleDI {}
