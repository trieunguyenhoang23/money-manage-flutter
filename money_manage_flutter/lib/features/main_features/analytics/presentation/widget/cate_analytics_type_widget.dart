import 'package:money_manage_flutter/core/extension/context_extension.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_manage_flutter/export/shared.dart';
import '../../../../../core/enum/transaction_type.dart';
import '../provider/cate_analytics_provider.dart';

class CategoryAnalyticsTypeWidget extends ConsumerWidget {
  final TransactionType type;

  const CategoryAnalyticsTypeWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(cateAnalyticsProvider(type));

    return analyticsAsync.when(
      data: (analytic) {
        if (analytic.isEmpty) {
          return Center(child: TextGGStyle(context.lang.no_data, 0.04.sw));
        }

        return AspectRatio(
          aspectRatio: 1.3,
          child: PieChart(
            PieChartData(
              sections: analytic,
              centerSpaceRadius: 50,
              sectionsSpace: 2,
            ),
          ),
        );
      },
      error: (err, stack) => Center(child: TextGGStyle("Error: $err", 0.05.sw)),
      loading: () => const LoadingWidget(),
    );
  }
}
