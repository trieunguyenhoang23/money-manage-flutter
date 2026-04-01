import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:money_manage_flutter/core/enum/transaction_type.dart';
import 'package:money_manage_flutter/features/main_features/transactions/data/model/local/transaction_local_model.dart';

@LazySingleton()
class AnalyticsLocalDatasource {
  final Isar _isar;

  AnalyticsLocalDatasource(this._isar);

  Future<double> getIncome() async {
    return _isar.transactionLocalModels
        .filter()
        .typeEqualTo(TransactionType.INCOME)
        .amountProperty()
        .sum();
  }

  Future<double> getExpense() async {
    return _isar.transactionLocalModels
        .filter()
        .typeEqualTo(TransactionType.EXPENSE)
        .amountProperty()
        .sum();
  }
}
