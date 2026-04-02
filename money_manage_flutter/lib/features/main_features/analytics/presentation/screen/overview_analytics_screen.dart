import 'package:money_manage_flutter/core/extension/context_extension.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';

import '../widget/date_range_pick_widget.dart';
import '../widget/overview_analytics/overview_line_graph_widget.dart';

class OverviewAnalyticsScreen extends StatefulWidget {
  const OverviewAnalyticsScreen({super.key});

  @override
  State<OverviewAnalyticsScreen> createState() =>
      _OverviewAnalyticsScreenState();
}

class _OverviewAnalyticsScreenState extends State<OverviewAnalyticsScreen> {
  List<Widget> widgets = [
    const DateRangePickWidget(),
    const OverviewLineGraphWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: context.lang.analytic_overview),
      body: PaddingStyle(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            for (var widget in widgets) ...[const SpacingStyle(), widget],
          ],
        ),
      ),
    );
  }
}
