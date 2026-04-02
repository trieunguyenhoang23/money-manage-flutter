import 'package:money_manage_flutter/core/extension/context_extension.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';
import '../../../../../core/enum/transaction_type.dart';
import '../widget/cate_analytics_type_widget.dart';
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
            CategoryAnalyticsTypeWidget(type: TransactionType.INCOME),
            CategoryAnalyticsTypeWidget(type: TransactionType.EXPENSE),
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
