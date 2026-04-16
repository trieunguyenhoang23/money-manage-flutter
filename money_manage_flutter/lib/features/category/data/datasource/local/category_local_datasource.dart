import 'package:isar_community/isar.dart';
import 'package:money_manage_flutter/core/enum/transaction_type.dart';
import 'package:money_manage_flutter/export/core_external.dart';
import '../../model/local/category_local_model.dart';

@LazySingleton()
class CategoryLocalDatasource {
  final Isar _isar;

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

  Future<void> save(CategoryLocalModel input) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.categoryLocalModels
          .filter()
          .idServerEqualTo(input.idServer)
          .findFirst();

      if (existing != null) {
        existing
          ..name = input.name
          ..description = input.description
          ..type = input.type
          ..createdAt = input.createdAt ?? existing.createdAt
          ..updatedAt = input.updatedAt ?? DateTime.now()
          ..userId = input.userId ?? existing.userId
          ..isSynced = input.isSynced;

        await _isar.categoryLocalModels.put(existing);
      } else {
        await _isar.categoryLocalModels.put(input);
      }
    });
  }

  Future<void> saveAll(List<CategoryLocalModel> cates) async {
    await _isar.writeTxn(() async {
      for (final item in cates) {
        final existing = await _isar.categoryLocalModels
            .filter()
            .idServerEqualTo(item.idServer)
            .findFirst();

        if (existing != null) {
          existing
            ..name = item.name
            ..description = item.description
            ..type = item.type
            ..createdAt = item.createdAt ?? existing.createdAt
            ..updatedAt = item.updatedAt ?? DateTime.now()
            ..userId = item.userId ?? existing.userId
            ..isSynced = item.isSynced;

          await _isar.categoryLocalModels.put(existing);
        } else {
          await _isar.categoryLocalModels.put(item);
        }
      }
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
