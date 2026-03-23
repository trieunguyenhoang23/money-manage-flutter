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

  Future<List<CategoryLocalModel>> getRecentActiveCategories(
    int range,
    TransactionType type,
  ) async {
    // Get the latest transactions
    final transactions = await _isar.transactionLocalModels
        .filter()
        .typeEqualTo(type)
        .sortByCreatedAtDesc()
        .limit(range)
        .findAll();

    final categories = <CategoryLocalModel>[];
    final categoryIds = <String>{};

    for (var tx in transactions) {
      await tx.category.load();

      final category = tx.category.value;
      if (category != null && !categoryIds.contains(category.idServer)) {
        categories.add(category);
        categoryIds.add(category.idServer);
      }

      if (categories.length >= range) break;
    }

    //Fallback
    if (categories.isEmpty || categoryIds.length - range < 0) {
      final moreLoadingCate = await _isar.categoryLocalModels
          .filter()
          .typeEqualTo(type)
          .limit(range)
          .findAll();

      categories.addAll(moreLoadingCate);
    }

    return categories;
  }

  Future<void> addTransaction(TransactionLocalModel transaction) async {
    _isar.writeTxn(() async {
      await _isar.transactionLocalModels.put(transaction);
    });
  }
}
