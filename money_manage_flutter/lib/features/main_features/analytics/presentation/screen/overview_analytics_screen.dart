import 'package:money_manage_flutter/core/extension/context_extension.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../widget/date_range_pick_widget.dart';
import '../widget/overview_analytics/overview_gird_view_widget.dart';
import '../widget/overview_analytics/overview_line_graph_widget.dart';
import '../widget/overview_analytics/overview_note_widget.dart';

class OverviewAnalyticsScreen extends StatefulWidget {
  const OverviewAnalyticsScreen({super.key});

  @override
  State<OverviewAnalyticsScreen> createState() =>
      _OverviewAnalyticsScreenState();
}

class _OverviewAnalyticsScreenState extends State<OverviewAnalyticsScreen> {
  List<Widget> widgets = const [
    DateRangePickWidget(),
    OverviewLineGraphWidget(),
    OverviewNoteWidget(),
    OverviewGirdViewWidget(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: context.lang.analytic_overview),
      body: PaddingStyle(
        child: CustomScrollView(
          slivers: [
            for (var widget in widgets) ...[
              const SliverToBoxAdapter(child: SpacingStyle()),
              SliverToBoxAdapter(child: widget),
            ],
          ],
        ),
      ),
    );
  }
}
