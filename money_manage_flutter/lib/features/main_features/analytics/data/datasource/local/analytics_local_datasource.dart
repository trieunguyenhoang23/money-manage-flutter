import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:money_manage_flutter/core/enum/transaction_type.dart';
import 'package:money_manage_flutter/core/utils/string_utils.dart';
import 'package:money_manage_flutter/features/category/data/model/local/category_local_model.dart';
import 'package:money_manage_flutter/features/main_features/analytics/data/model/category_analytics_model.dart';
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

  Future<List<CategoryAnalytics>> getCategoryAnalytics(
    TransactionType type,
    DateTime dateStart,
    DateTime dateEnd,
  ) async {
    // Date range
    final lower = DateTime(dateStart.year, dateStart.month, dateStart.day);
    final upper = DateTime(
      dateEnd.year,
      dateEnd.month,
      dateEnd.day,
      23,
      59,
      59,
    );

    final categories = await _isar.categoryLocalModels
        .filter()
        .typeEqualTo(type)
        .findAll();

    final transactions = await _isar.transactionLocalModels
        .filter()
        .typeEqualTo(type)
        .and()
        .transactionAtBetween(lower, upper)
        .findAll();

    return categories
        .map((category) {
          final relatedTransactions = transactions
              .where((tx) => tx.categoryId == category.idServer)
              .toList();

          // Sum the amounts
          final totalAmount = relatedTransactions.fold<double>(
            0,
            (sum, tx) => sum + (tx.amount),
          );

          return CategoryAnalytics(
            id: category.idServer.toString(),
            name: category.name ?? '',
            type: category.type != null
                ? category.type!.name
                : TransactionType.INCOME.name,
            totalAmount: totalAmount,
            transactionCount: relatedTransactions.length,
          );
        })
        .where((element) => element.totalAmount > 0)
        .toList();
  }

  Future<Map<String, dynamic>> getCumulativeData(
    DateTime start,
    DateTime end,
    String groupBy,
  ) async {
    /// GET opening INCOME & EXPENSE
    double runningIncome = await _isar.transactionLocalModels
        .filter()
        .transactionAtLessThan(start)
        .typeEqualTo(TransactionType.INCOME)
        .amountProperty()
        .sum();

    double runningExpense = await _isar.transactionLocalModels
        .filter()
        .transactionAtLessThan(start)
        .typeEqualTo(TransactionType.EXPENSE)
        .amountProperty()
        .sum();

    /// GET transaction by date range
    final transactions = await _isar.transactionLocalModels
        .filter()
        .transactionAtBetween(start, end)
        .sortByTransactionAt()
        .findAll();

    /// Mapping data by label
    final Map<String, _PeriodSum> groupedMap = {};
    for (var tx in transactions) {
      final key = StringUtils.formatGroupKey(tx.transactionAt, groupBy);
      groupedMap.putIfAbsent(key, () => _PeriodSum());

      if (tx.type == TransactionType.INCOME) {
        groupedMap[key]!.income += tx.amount;
      } else {
        groupedMap[key]!.expense += tx.amount;
      }
    }

    final sortedKeys = groupedMap.keys.toList()..sort();
    final List<Map<String, dynamic>> cumulativeData = [];

    for (var key in sortedKeys) {
      final period = groupedMap[key]!;

      /// Cumulative logic
      runningIncome += period.income;
      runningExpense += period.expense;

      cumulativeData.add({
        'label': key,
        'income': runningIncome, // In = Σ Income_t
        'expense': runningExpense, // En = Σ Expense_t
      });
    }

    return {'data': cumulativeData};
  }
}

class _PeriodSum {
  double income = 0;
  double expense = 0;
}
