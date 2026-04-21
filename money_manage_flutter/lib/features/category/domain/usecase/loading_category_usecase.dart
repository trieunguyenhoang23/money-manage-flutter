import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../../sync/data/datasource/local/sync_local_storage.dart';
import '../../data/model/local/category_local_model.dart';
import '../repositories/category_repository.dart';

@LazySingleton()
class LoadingCategoryUseCase {
  final CategoryRepository _repository;
  final SyncLocalStorage _syncLocalStorage;

  LoadingCategoryUseCase(this._repository, this._syncLocalStorage);

  int get _limit => SizeAppUtils().isTablet ? 20 : 10;

  Future<List<CategoryLocalModel>> execute(int page) async {
    final isSynced = _syncLocalStorage.isFirstSyncCompleted(
      SyncSchema.category,
    );

    return await _repository.loadCategoryByPage(page, _limit, isSynced);
  }
}
