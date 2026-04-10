import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';
import '../../../../profile/presentation/provider/currency_provider.dart';
import '../../../data/model/category_analytics_model.dart';

class CateAnalyticsItemWidget extends StatelessWidget {
  final CategoryAnalytics item;

  const CateAnalyticsItemWidget({super.key, required this.item});

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Row(
                        children: [
                          Container(
                            width: 0.1 * cc.maxWidth,
                            height: 0.1 * cc.maxWidth,
                            color: generateUniqueColorById(item.id),
                          ),
                          SizedBox(width: 0.05 * cc.maxWidth),
                          Expanded(
                            child: TextGGStyle(
                              item.name,
                              textSize1,
                              maxLines: 2,
                              isAutoSizeText: false,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: Consumer(
                        builder: (context, ref, _) {
                          final currency =
                              ref.read(currencyProvider).value ?? 'VND';
                          return TextGGStyle(
                            StringUtils.formatPrice(
                              item.totalAmount.toString(),
                              currency,
                            ),
                            textSize1,
                            fontWeight: FontWeight.bold,
                            maxLines: 2,
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextGGStyle(context.lang.transaction, textSize2),
                    TextGGStyle(
                      '${item.transactionCount.toString()} ',
                      textSize1,
                      fontWeight: FontWeight.bold,
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
