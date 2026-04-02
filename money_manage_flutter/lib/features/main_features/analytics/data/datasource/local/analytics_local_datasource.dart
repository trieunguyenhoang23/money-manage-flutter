import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:money_manage_flutter/core/enum/transaction_type.dart';
import 'package:money_manage_flutter/features/category/data/model/local/category_local_model.dart';
import 'package:money_manage_flutter/features/main_features/analytics/data/model/category_analytics_model.dart';
import 'package:money_manage_flutter/features/main_features/transactions/data/model/local/transaction_local_model.dart';

import '../../model/overview_analytics_model.dart';

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

  Future<OverviewAnalytics> getOverview(
    DateTime startDate,
    DateTime endDate,
  ) async {
    // Normalize Dates
    final start = DateTime(
      startDate.year,
      startDate.month,
      startDate.day,
      0,
      0,
      0,
    );
    final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);

    final diffInDays = end.difference(start).inDays;
    String groupBy = (diffInDays <= 31)
        ? 'day'
        : (diffInDays <= 900)
        ? 'month'
        : 'year';

    // Calculate Initial Totals (Opening Balance)
    final pastTransactions = await _isar.transactionLocalModels
        .filter()
        .transactionAtLessThan(start)
        .findAll();

    double runningIncome = 0;
    double runningExpense = 0;
    for (var tx in pastTransactions) {
      if (tx.type == TransactionType.INCOME) {
        runningIncome += tx.amount;
      } else {
        runningExpense += tx.amount;
      }
    }
    double runningBalance = runningIncome - runningExpense;

    // Fetch Current Range Transactions
    final currentTransactions = await _isar.transactionLocalModels
        .filter()
        .transactionAtBetween(start, end)
        .sortByTransactionAt()
        .findAll();

    // Fill missing slots (Jan, Feb, etc.)
    final Map<String, _PeriodSum> groupedMap = {};

    // Aggregate actual data into slots
    for (var tx in currentTransactions) {
      final key = _getGroupKey(tx.transactionAt, groupBy);

      groupedMap.putIfAbsent(key, () => _PeriodSum());

      if (tx.type == TransactionType.INCOME) {
        groupedMap[key]!.income += tx.amount;
      } else {
        groupedMap[key]!.expense += tx.amount;
      }
    }

    // Cumulative Transformation
    final List<OverviewPoint> points = [];
    final sortedKeys = groupedMap.keys.toList()..sort();

    for (var key in sortedKeys) {
      final period = groupedMap[key]!;

      // Add current period activity to the totals from the PAST
      runningIncome += period.income;
      runningExpense += period.expense;

      // Calculate the balance based on the NEW totals
      runningBalance = runningIncome - runningExpense;

      points.add(
        OverviewPoint(
          label: key,
          income: runningIncome,
          expense: runningExpense,
          balance: runningBalance,
        ),
      );
    }

    return OverviewAnalytics(groupType: groupBy, points: points);
  }
}

class _PeriodSum {
  double income = 0;
  double expense = 0;
}

String _getGroupKey(DateTime date, String groupBy) {
  if (groupBy == 'year') return "${date.year}";
  if (groupBy == 'month') {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}";
  }
  return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
}
