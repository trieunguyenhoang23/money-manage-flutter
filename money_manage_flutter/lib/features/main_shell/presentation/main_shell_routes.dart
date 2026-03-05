import 'package:money_manage_flutter/export/router.dart';

class MainShellRoutes {
  static final mainRoutes = StatefulShellRoute.indexedStack(
    builder: (context, state, navigationShell) {
      return MainShellScreen(navigationShell: navigationShell);
    },
    branches: [
      StatefulShellBranch(routes: [TransactionsRoutes.routes.first]),
      StatefulShellBranch(routes: [AnalyticRoutes.routes.first]),
      StatefulShellBranch(routes: [ProfileRoutes.routes.first]),
    ],
  );
}
