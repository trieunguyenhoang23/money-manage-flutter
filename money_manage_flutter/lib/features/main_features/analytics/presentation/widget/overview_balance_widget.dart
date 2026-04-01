import 'package:dartz/dartz.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../../profile/presentation/provider/currency_provider.dart';
import '../provider/overview_balance_provider.dart';
import 'package:money_manage_flutter/export/shared.dart';

class OverviewBalanceWidget extends ConsumerWidget {
  const OverviewBalanceWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Tuple2<String, Provider<double>>> amountInfo = [
      Tuple2(context.lang.balance, balanceProvider),
      Tuple2(context.lang.income, incomeProvider),
      Tuple2(context.lang.expense, expenseProvider),
    ];

    double wFrame = 1.sw - 0.05.sw * 2;
    double hFrame = wFrame * 80 / 375;

    return Container(
      width: wFrame,
      height: hFrame,
      decoration: BoxDecoration(
        color: context.colorScheme.surface,
        borderRadius: BorderRadius.all(Radius.circular(hFrame * 0.05)),
        // boxShadow: [],
      ),
      child: Row(
        children: [
          Consumer(
            builder: (context, ref, _) {
              final isShowData =
                  ref.watch(
                    overviewBalanceProvider.select((s) => s.value?.isShowData),
                  ) ??
                  true;
              return IconButton(
                onPressed: () {
                  ref
                      .read(overviewBalanceProvider.notifier)
                      .updateShowData(!isShowData);
                },
                icon: Icon(
                  isShowData ? Icons.visibility : Icons.visibility_off,
                ),
              );
            },
          ),
          Expanded(
            child: Center(
              child: GridViewBuilder(
                crossAxisCount: amountInfo.length,
                itemCount: amountInfo.length,

                itemBuilder: (context, index) {
                  Tuple2<String, Provider<double>> item = amountInfo[index];
                  return OverViewItemWidget(
                    title: item.value1,
                    amountProvider: item.value2,
                  );
                },
                childAspectRatio: 70 / 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OverViewItemWidget extends StatelessWidget {
  final String title;
  final Provider<double> amountProvider;

  const OverViewItemWidget({
    super.key,
    required this.title,
    required this.amountProvider,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cc) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 5,
              child: Container(
                alignment: Alignment.center,
                child: TextGGStyle(title, cc.maxHeight * 0.2, maxLines: 1),
              ),
            ),

            Flexible(
              flex: 5,
              child: Consumer(
                builder: (context, ref, _) {
                  final amountState = ref.watch(amountProvider);
                  final currency = ref.watch(currencyProvider);
                  final isShowData =
                      ref.watch(
                        overviewBalanceProvider.select(
                          (s) => s.value?.isShowData,
                        ),
                      ) ??
                      true;

                  if (!isShowData) {
                    return TextGGStyle(
                      "******",
                      cc.maxHeight * 0.25,
                      fontWeight: FontWeight.bold,
                    );
                  }

                  return TextGGStyle(
                    StringUtils.formatPrice(
                      amountState.toString(),
                      currency.value ?? 'VND',
                    ),
                    cc.maxHeight * 0.25,
                    maxLines: 1,
                    fontWeight: FontWeight.bold,
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
