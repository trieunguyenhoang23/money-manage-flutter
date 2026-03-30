import 'package:money_manage_flutter/core/extension/context_extension.dart';
import 'package:money_manage_flutter/export/ui_external.dart';

enum TransactionType {
  INCOME,
  EXPENSE;

  static TransactionType fromDynamic(dynamic value) {
    if (value is TransactionType) return value;

    if (value is String) {
      return TransactionType.values.firstWhere(
        (e) => e.name.toUpperCase() == value.toUpperCase(),
        orElse: () =>
            TransactionType.EXPENSE, // Giá trị mặc định nếu không khớp
      );
    }

    return TransactionType.EXPENSE;
  }

  bool get isIncome => this == TransactionType.INCOME;

  bool get isExpense => this == TransactionType.EXPENSE;

  String displayTitle(BuildContext context) {
    switch (this) {
      case TransactionType.INCOME:
        return context.lang.income;
      case TransactionType.EXPENSE:
        return context.lang.expense;
    }
  }

  Color get color => isIncome ? Colors.green : Colors.red;
}
