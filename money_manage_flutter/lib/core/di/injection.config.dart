// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:isar_community/isar.dart' as _i214;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

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
import '../../infrastructure/network/dio_service.dart' as _i960;
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
    gh.lazySingleton<_i197.CategoryLocalDatasource>(
      () => _i197.CategoryLocalDatasource(gh<_i214.Isar>()),
    );
    await gh.lazySingletonAsync<_i361.Dio>(
      () => moduleDI.dioWithCacheInstance(),
      instanceName: 'dioWithCache',
      preResolve: true,
    );
    gh.lazySingleton<_i361.Dio>(
      () => moduleDI.dioNoCacheInstance,
      instanceName: 'dioNoCache',
    );
    gh.lazySingleton<_i960.DioService>(
      () => _i960.DioService(
        gh<_i361.Dio>(instanceName: 'dioWithCache'),
        gh<_i361.Dio>(instanceName: 'dioNoCache'),
      ),
    );
    gh.lazySingleton<_i702.CategoryRemoteDatasource>(
      () => _i702.CategoryRemoteDatasource(gh<_i989.DioService>()),
    );
    gh.lazySingleton<_i869.CategoryRepository>(
      () => _i528.CategoryRepositoryImpl(
        gh<_i702.CategoryRemoteDatasource>(),
        gh<_i197.CategoryLocalDatasource>(),
      ),
    );
    gh.lazySingleton<_i845.CreateCategoryUseCase>(
      () => _i845.CreateCategoryUseCase(gh<_i869.CategoryRepository>()),
    );
    gh.lazySingleton<_i617.EditCategoryUseCase>(
      () => _i617.EditCategoryUseCase(gh<_i869.CategoryRepository>()),
    );
    gh.lazySingleton<_i1069.LoadingCategoryUseCase>(
      () => _i1069.LoadingCategoryUseCase(gh<_i869.CategoryRepository>()),
    );
    return this;
  }
}

class _$ModuleDI extends _i633.ModuleDI {}
