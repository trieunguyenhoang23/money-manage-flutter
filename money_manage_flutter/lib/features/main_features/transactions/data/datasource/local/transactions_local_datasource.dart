import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:money_manage_flutter/core/enum/transaction_type.dart';
import '../../../../../category/data/model/local/category_local_model.dart';
import '../../model/local/transaction_local_model.dart';

@LazySingleton()
class TransactionsLocalDatasource {
  final Isar _isar;

  TransactionsLocalDatasource(this._isar);

  Future<List<TransactionLocalModel>> loadByPage(
    int page,
    int limitCount,
  ) async {
    return await _isar.transactionLocalModels
        .where()
        .sortByCreatedAtDesc()
        .offset(page * limitCount)
        .limit(limitCount)
        .findAll();
  }

  Future<List<TransactionLocalModel>> loadDataNotYetSync(int limitCount) async {
    return await _isar.transactionLocalModels
        .filter()
        .isSyncedEqualTo(false)
        .sortByCreatedAtDesc()
        .offset(0 * limitCount)
        .limit(limitCount)
        .findAll();
  }

  Future<int> getLengthDataNotYetSync() async {
    return await _isar.transactionLocalModels
        .filter()
        .isSyncedEqualTo(false)
        .count();
  }

  Future<int> getLengthData() async {
    return await _isar.transactionLocalModels.count();
  }

  Future<List<CategoryLocalModel>> getRecentActiveCategories(
    int range,
    TransactionType type,
  ) async {
    final transactions = await _isar.transactionLocalModels
        .filter()
        .typeEqualTo(type)
        .sortByCreatedAtDesc()
        .limit(range * 3) // Take extra to avoid a lack of uniqueness
        .findAll();

    final result = <CategoryLocalModel>[];
    final seen = <String>{};

    // Priority get Cate from transaction
    for (final tx in transactions) {
      final category = tx.category.value;

      if (category == null) continue;

      final id = category.idServer;
      if (seen.contains(id)) continue;

      seen.add(id!);
      result.add(category);

      if (result.length >= range) {
        return result;
      }
    }

    // fallback if needing additional data
    final fallback = await _isar.categoryLocalModels
        .filter()
        .typeEqualTo(type)
        .findAll();

    for (final cate in fallback) {
      final id = cate.idServer;
      if (seen.contains(id)) continue;

      seen.add(id!);
      result.add(cate);

      if (result.length >= range) break;
    }

    return result;
  }

  Future<void> putTransaction(
    TransactionLocalModel transaction,
    CategoryLocalModel category,
  ) async {
    _isar.writeTxn(() async {
      await _isar.transactionLocalModels.put(transaction);

      // Link the category
      transaction.category.value = category;

      // Save the link
      await transaction.category.save();
    });
  }

  Future<void> saveAll(List<TransactionLocalModel> transactions) async {
    await _isar.writeTxn(() async {
      // 1. Bulk insert all transactions first
      // This returns the internal Isar IDs if they were null/auto-increment
      await _isar.transactionLocalModels.putAll(transactions);

      // 2. Prepare all links
      // We iterate through and ensure the category link is set and saved
      for (var tx in transactions) {
        // Note: This assumes tx.category.value was already assigned
        // before calling saveAll. If not, you'd assign it here.
        await tx.category.save();
      }
    });
  }

  Future<void> removeTransaction(TransactionLocalModel transaction) async {
    _isar.writeTxn(() async {
      await _isar.transactionLocalModels.delete(transaction.id);
    });
  }

  Future<void> clearAll() async {
    await _isar.writeTxn(() async {
      await _isar.transactionLocalModels.clear();
    });
  }

  Future<void> markAllAsSynced(
    List<TransactionLocalModel> list,
    String userId,
  ) async {
    await _isar.writeTxn(() async {
      for (var item in list) {
        item
          ..isSynced = true
          ..userId = userId;
      }
      await _isar.transactionLocalModels.putAll(list);
    });
  }
}
