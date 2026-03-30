import 'package:isar_community/isar.dart';
import 'package:money_manage_flutter/core/enum/transaction_type.dart';
import 'package:money_manage_flutter/export/core_external.dart';
import '../../model/local/category_local_model.dart';

@LazySingleton()
class CategoryLocalDatasource {
  Isar _isar;

  CategoryLocalDatasource(this._isar);

  Future<List<CategoryLocalModel>> getAll() async {
    return await _isar.categoryLocalModels.where().findAll();
  }

  Future<List<CategoryLocalModel>> loadByPage(int page, int limitCount) async {
    return await _isar.categoryLocalModels
        .where()
        .sortByCreatedAtDesc()
        .offset(page * limitCount)
        .limit(limitCount)
        .findAll();
  }

  Future<List<CategoryLocalModel>> loadByType(
    int page,
    int limitCount,
    TransactionType type,
  ) async {
    return await _isar.categoryLocalModels
        .filter()
        .typeEqualTo(type)
        .sortByCreatedAtDesc()
        .offset(page * limitCount)
        .limit(limitCount)
        .findAll();
  }

  Future<List<CategoryLocalModel>> loadDataNotYetSync(int limitCount) async {
    return await _isar.categoryLocalModels
        .filter()
        .isSyncedEqualTo(false)
        .sortByCreatedAtDesc()
        .offset(0 * limitCount)
        .limit(limitCount)
        .findAll();
  }

  Future<int> getLengthDataNotYetSync() async {
    return await _isar.categoryLocalModels
        .filter()
        .isSyncedEqualTo(false)
        .count();
  }

  Future<int> getLengthData() async {
    return await _isar.categoryLocalModels.count();
  }

  Future<void> save(CategoryLocalModel cate) async {
    await _isar.writeTxn(() async {
      await _isar.categoryLocalModels.put(cate);
    });
  }

  Future<void> saveAll(List<CategoryLocalModel> cates) async {
    await _isar.writeTxn(() async {
      await _isar.categoryLocalModels.putAll(cates);
    });
  }

  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.categoryLocalModels.clear();
    });
  }

  Future<void> markAllAsSynced(
    List<CategoryLocalModel> list,
    String userId,
  ) async {
    await _isar.writeTxn(() async {
      for (var item in list) {
        item
          ..isSynced = true
          ..userId = userId;
      }
      await _isar.categoryLocalModels.putAll(list);
    });
  }
}
