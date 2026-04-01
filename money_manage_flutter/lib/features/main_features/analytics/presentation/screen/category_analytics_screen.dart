import 'package:money_manage_flutter/core/extension/context_extension.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';
import '../../../../../core/enum/transaction_type.dart';
import '../widget/cate_analytics_type_widget.dart';

class CategoryAnalyticsScreen extends HookConsumerWidget {
  const CategoryAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);

    return Scaffold(
      appBar: AppBarWidget(title: context.lang.analytic_category),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SpacingStyle(),
          TabBarWidget(
            tabController: tabController,
            listType: [context.lang.income, context.lang.expense],
          ),
          const SpacingStyle(),
          Expanded(
            child: Consumer(
              builder: (context, ref, _) {
                return TabBarView(
                  controller: tabController,
                  children: const [
                    CategoryAnalyticsTypeWidget(type: TransactionType.INCOME),
                    CategoryAnalyticsTypeWidget(type: TransactionType.EXPENSE),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
