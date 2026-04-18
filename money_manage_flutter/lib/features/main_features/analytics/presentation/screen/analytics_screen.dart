import 'package:money_manage_flutter/core/extension/context_extension.dart';
import 'package:money_manage_flutter/export/router.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../widget/analytics_widget.dart';
import '../widget/overview_balance_widget.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  @override
  Widget build(BuildContext context) {
    List<Widget> analyticsWidgets = [
      const OverviewBalanceWidget(),
      AnalyticsWidget(
        title: context.lang.analytic_overview,
        iconData: Icons.stacked_line_chart,
        namePath: AnalyticRoutes.overviewAnalyticName,
      ),
      AnalyticsWidget(
        title: context.lang.analytic_category,
        iconData: Icons.pie_chart,
        namePath: AnalyticRoutes.cateAnalyticName,
      ),
    ];

    return PaddingStyle(
      child: CustomScrollView(
        slivers: [
          for (var widget in analyticsWidgets) ...[
            const SliverToBoxAdapter(child: SpacingStyle()),
            SliverToBoxAdapter(child: widget),
          ],
        ],
      ),
    );
  }
}
