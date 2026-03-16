import 'package:money_manage_flutter/core/extension/context_extension.dart';
import 'package:money_manage_flutter/export/ui_external.dart';

enum TransactionType {
  INCOME,
  EXPENSE;

  String displayTitle(BuildContext context) {
    switch (this) {
      case TransactionType.INCOME:
        return context.lang.income;
      case TransactionType.EXPENSE:
        return context.lang.expense;
    }
  }

  Color get color => this == TransactionType.INCOME ? Colors.green : Colors.red;
}
