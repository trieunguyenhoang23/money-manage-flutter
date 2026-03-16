import 'package:money_manage_flutter/core/enum/transaction_type.dart';
import 'package:money_manage_flutter/export/core_external.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../datasource/local/transactions_local_datasource.dart';
import '../datasource/remote/transactions_remote_datasource.dart';
import '../model/local/transaction_local_model.dart';

@LazySingleton(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionsRemoteDatasource _remoteDatasource;
  final TransactionsLocalDatasource _localDatasource;

  TransactionRepositoryImpl(this._remoteDatasource, this._localDatasource);

  @override
  Future<List<CategoryLocalModel>> getCategoryThroughTrans(
    TransactionType type,
    int range,
  ) async {
    return await _localDatasource.getRecentActiveCategories(range, type);
  }
}
