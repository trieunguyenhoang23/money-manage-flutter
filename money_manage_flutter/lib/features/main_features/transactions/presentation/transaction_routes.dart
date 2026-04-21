import 'package:money_manage_flutter/core/router/app_router.dart';
import 'package:money_manage_flutter/export/router.dart';
import '../data/model/local/transaction_local_model.dart';
import 'screen/create_transaction_screen.dart';
import 'screen/edit_transaction_screen.dart';

class TransactionsRoutes {
  static const transactionsPath = '/transactions';
  static const transactionsName = 'transactions';

  static const createNewTransactionPath = 'createNewTransactionPath';
  static const createNewTransactionName = 'createNewTransactionName';

  static const editTransactionPath = 'editTransactionPath';
  static const editTransactionName = 'editTransactionName';

  static final routes = [
    GoRoute(
      path: transactionsPath,
      name: transactionsName,
      builder: (context, state) => const TransactionsScreen(),
      routes: [
        GoRoute(
          path: createNewTransactionPath,
          name: createNewTransactionName,
          parentNavigatorKey: appNavigatorKey,
          builder: (context, state) => const CreateTransactionScreen(),
        ),
        GoRoute(
          path: editTransactionPath,
          name: editTransactionName,
          parentNavigatorKey: appNavigatorKey,
          builder: (context, state) {
            final transaction = state.extra as TransactionLocalModel;
            return EditTransactionScreen(item: transaction);
          },
        ),
      ],
    ),
  ];
}
