import 'package:money_manage_flutter/core/extension/context_extension.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_manage_flutter/export/shared.dart';
import '../../../../../core/enum/transaction_type.dart';
import '../../data/model/category_analytics_model.dart';
import '../provider/cate_analytics_provider.dart';
import 'cate_analytics_item_widget.dart';

class CategoryAnalyticsTypeWidget extends ConsumerWidget {
  final TransactionType type;

  const CategoryAnalyticsTypeWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRange = ref.watch(analyticsDateRangeProvider);

    final analyticsAsync = ref.watch(
      cateAnalyticsProvider(
        AnalyticsParam(
          type: type,
          startDate: dateRange.start,
          endDate: dateRange.end,
        ),
      ),
    );

    return PaddingStyle(
      child: analyticsAsync.when(
        data: (analytic) {
          if (analytic.value1.isEmpty && analytic.value2.isEmpty) {
            return Center(child: TextGGStyle(context.lang.no_data, 0.04.sw));
          }

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: AspectRatio(
                  aspectRatio: 1.3,
                  child: PieChart(
                    PieChartData(
                      sections: analytic.value1,
                      centerSpaceRadius: 50,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
              ),
              SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  CategoryAnalytics item = analytic.value2[index];
                  return CateAnalyticsItemWidget(item: item);
                }, childCount: analytic.value2.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 20,
                ),
              ),
            ],
          );
        },
        error: (err, stack) =>
            Center(child: TextGGStyle("Error: $err", 0.05.sw)),
        loading: () => const LoadingWidget(),
      ),
    );
  }
}
