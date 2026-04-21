import 'package:injectable/injectable.dart';
import '../../../../category/data/datasource/local/category_local_datasource.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../../../../main_features/transactions/data/datasource/local/transactions_local_datasource.dart';
import '../../../../main_features/transactions/data/model/local/transaction_local_model.dart';

@lazySingleton
class TransactionPullService {
  final CategoryLocalDatasource _categoryLocalDatasource;
  final TransactionsLocalDatasource _transactionsLocalDatasource;

  TransactionPullService(
    this._categoryLocalDatasource,
    this._transactionsLocalDatasource,
  );

  Future<void> saveCategoryIfNeeded(List<dynamic> rawData) async {
    final categories = rawData
        .map((item) => item['category'])
        .whereType<Map<String, dynamic>>()
        .map<CategoryLocalModel>((json) => CategoryLocalModel.fromRemote(json))
        .toSet() // Ensure not having duplicate category
        .toList();

    if (categories.isNotEmpty) {
      await _categoryLocalDatasource.saveAll(categories);
    }
  }

  Future<void> removeTransaction(List<dynamic> rawData) async {
    // Filter list ID need to remove
    final toDeleteIds = rawData
        .where((item) => item['is_deleted'] == true)
        .map((item) => item['id'].toString())
        .toList();

    // Delete data
    if (toDeleteIds.isNotEmpty) {
      await _transactionsLocalDatasource.deleteByServerIds(toDeleteIds);
    }
  }

  Future<List<TransactionLocalModel>> saveUpdatedTransaction(
    List<dynamic> rawData,
  ) async {
    // Filter updated data
    final toUpdate = rawData
        .where((item) => item['is_deleted'] != true)
        .map((item) => TransactionLocalModel.fromRemote(item))
        .toList();

    if (toUpdate.isNotEmpty) {
      await _transactionsLocalDatasource.saveAll(toUpdate);
    }

    return toUpdate;
  }
}
