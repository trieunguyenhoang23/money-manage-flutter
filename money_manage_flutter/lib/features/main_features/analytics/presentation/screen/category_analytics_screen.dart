import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';
import '../widget/cate_analytics/cate_pie_chart_widget.dart';
import '../widget/date_range_pick_widget.dart';

class CategoryAnalyticsScreen extends HookConsumerWidget {
  const CategoryAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);

    List<Widget> widgets = [
      const DateRangePickWidget(),
      TabBarWidget(
        tabController: tabController,
        listType: [context.lang.income, context.lang.expense],
      ),
      Expanded(
        child: TabBarView(
          controller: tabController,
          children: const [
            CatePieChartWidget(type: TransactionType.INCOME),
            CatePieChartWidget(type: TransactionType.EXPENSE),
          ],
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBarWidget(title: context.lang.analytic_category),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          for (var widget in widgets) ...[const SpacingStyle(), widget],
        ],
      ),
    );
  }
}
