import 'package:money_manage_flutter/core/extension/context_extension.dart';
import 'package:money_manage_flutter/core/utils/string_utils.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';
import '../../../profile/presentation/provider/currency_provider.dart';
import '../../data/model/category_analytics_model.dart';

class CateAnalyticsItemWidget extends StatelessWidget {
  final CategoryAnalytics item;

  const CateAnalyticsItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cc) {
        double textSize1 = cc.maxHeight * 0.2;
        double textSize2 = cc.maxHeight * 0.15;

        return Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.all(Radius.circular(cc.maxWidth * 0.05)),
          ),
          child: PaddingStyle(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextGGStyle(item.name, textSize1),
                    Consumer(
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
                        );
                      },
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
