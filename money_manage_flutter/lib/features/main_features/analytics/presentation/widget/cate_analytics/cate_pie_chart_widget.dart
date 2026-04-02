import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:money_manage_flutter/export/shared.dart';
import '../../../../profile/presentation/provider/currency_provider.dart';
import '../../../data/model/category_analytics_model.dart';
import '../../provider/cate_analytics_provider.dart';
import '../../provider/date_range_provider.dart';
import 'cate_analytics_item_widget.dart';

class CatePieChartWidget extends ConsumerWidget {
  final TransactionType type;

  const CatePieChartWidget({super.key, required this.type});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRange = ref.watch(dateRangeProvider);
    final currency = ref.read(currencyProvider);

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
              SliverToBoxAdapter(
                child: Container(
                  alignment: Alignment.center,
                  child: TextGGStyle(
                    StringUtils.formatPrice(
                      analytic.value3.toString(),
                      currency.value ?? 'VND',
                    ),
                    0.05.sw,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SpacingStyle()),
              SliverGrid(
                delegate: SliverChildBuilderDelegate((context, index) {
                  CategoryAnalytics item = analytic.value2[index];
                  return CateAnalyticsItemWidget(item: item);
                }, childCount: analytic.value2.length),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 20,
                  childAspectRatio: 2,
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
