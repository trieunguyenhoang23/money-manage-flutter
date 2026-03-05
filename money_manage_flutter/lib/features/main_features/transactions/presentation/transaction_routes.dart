import 'package:money_manage_flutter/export/router.dart';

class TransactionsRoutes {
  static const transactionsPath = '/transactions';
  static const transactionsName = 'transactions';

  static final routes = [
    GoRoute(
      path: transactionsPath,
      name: transactionsName,
      builder: (context, state) => const TransactionsScreen(),
    ),
  ];
}
