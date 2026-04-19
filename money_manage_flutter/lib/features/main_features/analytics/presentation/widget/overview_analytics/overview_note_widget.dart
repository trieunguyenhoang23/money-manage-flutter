import 'package:dartz/dartz.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/features/main_features/profile/presentation/provider/currency_provider.dart';
import '../../../data/model/overview_analytics_model.dart';
import '../../provider/overview_analytics_provider.dart';

class OverviewNoteWidget extends ConsumerWidget {
  const OverviewNoteWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final overviewGraphState = ref.watch(overviewGraphProvider);

    return overviewGraphState.when(
      loading: () => const LoadingWidget(),
      error: (err, _) => Center(child: TextGGStyle("Error: $err", 14)),
      data: (data) {
        if (data.overViewAnalytics == null) return const SizedBox.shrink();
        OverviewAnalytics overviewAnalytics = data.overViewAnalytics!;
        final currency = ref.read(currencyProvider);

        List<Tuple2<String, Color>> overviewType = [
          Tuple2(context.lang.balance, ColorConstant.warning500),
          Tuple2(context.lang.income, ColorConstant.success500),
          Tuple2(context.lang.expense, ColorConstant.error500),
        ];

        double textSize = 0.035.sw.clamp(15, 20);

        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextGGStyle(
                  '${context.lang.profile_currency}: ${currency.value}',
                  textSize,
                ),
                TextGGStyle(
                  '${context.lang.analytic_time_line}: ${overviewAnalytics.groupType.toUpperCase()}',
                  textSize,
                ),
              ],
            ),
            SizedBox(height: 0.01.sh),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                for (var overViewItem in overviewType)
                  SizedBox(
                    width: 0.8.sw / overviewType.length,
                    height: 0.025.sh,
                    child: _itemOverviewWidget(overViewItem),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _itemOverviewWidget(Tuple2<String, Color> item) {
    return LayoutBuilder(
      builder: (context, cc) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: cc.maxWidth * 0.3,
              height: cc.maxHeight * 0.2,
              color: item.value2,
            ),
            SizedBox(width: cc.maxWidth * 0.05),
            Flexible(
              child: TextGGStyle(
                item.value1,
                cc.maxHeight * 0.5,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        );
      },
    );
  }
}
