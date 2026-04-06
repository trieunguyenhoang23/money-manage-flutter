import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:money_manage_flutter/core/enum/transaction_type.dart';
import '../../../../../category/data/model/local/category_local_model.dart';
import '../../model/local/transaction_local_model.dart';

@LazySingleton()
class TransactionsLocalDatasource {
  final Isar _isar;

  TransactionsLocalDatasource(this._isar);

  Future<List<TransactionLocalModel>> loadTransByMonth({
    required int page,
    required int limitCount,
    required int month,
    required int year,
    TransactionType? type,
  }) async {
    final startTime = DateTime(year, month, 1);
    final endTime = DateTime(year, month + 1, 0, 23, 59, 59);

    var query = _isar.transactionLocalModels.filter().transactionAtBetween(
      startTime,
      endTime,
    );

    if (type != null) {
      query = query.and().typeEqualTo(type);
    }

    final list = await query
        .sortByTransactionAtDesc()
        .offset(page * limitCount)
        .limit(limitCount)
        .findAll();

    for (var transaction in list) {
      await transaction.category.load();
    }

    return list;
  }

  Future<List<TransactionLocalModel>> loadDataNotYetSync(int limitCount) async {
    return await _isar.transactionLocalModels
        .filter()
        .isSyncedEqualTo(false)
        .sortByTransactionAtDesc()
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
    await _isar.writeTxn(() async {
      await _isar.transactionLocalModels.put(transaction);

      // Link the category
      transaction.category.value = category;

      // Save the link
      await transaction.category.save();
    });
  }

  Future<void> saveAll(List<TransactionLocalModel> transactions) async {
    await _isar.writeTxn(() async {
      for (var tx in transactions) {
        final existing = await _isar.transactionLocalModels
            .filter()
            .idServerEqualTo(tx.idServer)
            .findFirst();

        if (existing != null) {
          tx.id = existing.id;
        }

        if (tx.category.value == null && tx.categoryId.isNotEmpty) {
          final cate = await _isar.categoryLocalModels
              .filter()
              .idServerEqualTo(tx.categoryId)
              .findFirst();
          if (cate != null) {
            tx.category.value = cate;
          }
        }
      }

      await _isar.transactionLocalModels.putAll(transactions);

      for (var tx in transactions) {
        await tx.category.save();
      }
    });
  }

  Future<void> removeTransaction(TransactionLocalModel transaction) async {
    _isar.writeTxn(() async {
      await _isar.transactionLocalModels.delete(transaction.id);
    });
  }

  Future<void> deleteByServerIds(List<String> serverIds) async {
    await _isar.writeTxn(() async {
      await _isar.transactionLocalModels
          .filter()
          .anyOf(serverIds, (q, String id) => q.idServerEqualTo(id))
          .deleteAll();
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
