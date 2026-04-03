import 'package:money_manage_flutter/export/ui_external.dart';
import '../../../data/model/overview_analytics_model.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';

class OverviewItemWidget extends StatelessWidget {
  final OverviewPoint item;

  const OverviewItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cc) {
        double textSize1 = cc.maxHeight * 0.15;
        double textSize2 = cc.maxHeight * 0.125;

        return Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.all(Radius.circular(cc.maxWidth * 0.05)),
          ),
          child: Padding(
            padding: EdgeInsets.all(0.05 * cc.maxWidth),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Flexible(
                  child: TextGGStyle(
                    item.label,
                    textSize2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: TextGGStyle(
                        StringUtils.formatNumber(item.balance.toString()),
                        textSize1,
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.warning500,
                      ),
                    ),
                    if (item.trend != TrendingPattern.none)
                      if (item.trend == TrendingPattern.up)
                        const Icon(
                          Icons.trending_up,
                          color: ColorConstant.success700,
                        )
                      else if (item.trend == TrendingPattern.down)
                        const Icon(
                          Icons.trending_down,
                          color: ColorConstant.error700,
                        )
                      else
                        const Icon(
                          Icons.trending_flat,
                          color: ColorConstant.warning700,
                        ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: TextGGStyle(
                        StringUtils.formatNumber(item.expense.toString()),
                        textSize1,
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.error500,
                      ),
                    ),
                    Flexible(
                      child: TextGGStyle(
                        StringUtils.formatNumber(item.income.toString()),
                        textSize1,
                        fontWeight: FontWeight.bold,
                        color: ColorConstant.success500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
