import 'package:money_manage_flutter/core/router/app_router.dart';
import 'package:money_manage_flutter/export/router.dart';

class AnalyticRoutes {
  static const analyticName = 'analytic';
  static const analyticPath = '/analytic';

  static const cateAnalyticName = 'cateAnalytic';
  static const cateAnalyticPath = '/cateAnalytic';

  static const overviewAnalyticName = 'overviewAnalytic';
  static const overviewAnalyticPath = '/overviewAnalytic';

  static final routes = [
    GoRoute(
      path: analyticPath,
      name: analyticName,
      builder: (context, state) => const AnalyticsScreen(),
      routes: [
        GoRoute(
          path: cateAnalyticPath,
          name: cateAnalyticName,
          parentNavigatorKey: appNavigatorKey,
          builder: (context, state) => const CategoryAnalyticsScreen(),
        ),
        GoRoute(
          path: overviewAnalyticPath,
          name: overviewAnalyticName,
          parentNavigatorKey: appNavigatorKey,
          builder: (context, state) => const OverviewAnalyticsScreen(),
        ),
      ],
    ),
  ];
}
