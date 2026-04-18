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
    List<Tuple3<String, Provider<double>, Color>> amountInfo = [
      Tuple3(context.lang.balance, balanceProvider, ColorConstant.warning400),
      Tuple3(context.lang.income, incomeProvider, ColorConstant.success400),
      Tuple3(context.lang.expense, expenseProvider, ColorConstant.error400),
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
                  Tuple3<String, Provider<double>, Color> item =
                      amountInfo[index];
                  return OverViewItemWidget(
                    title: item.value1,
                    amountProvider: item.value2,
                    color: item.value3,
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
  final Color color;

  const OverViewItemWidget({
    super.key,
    required this.title,
    required this.amountProvider,
    required this.color,
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

                  return Row(
                    children: [
                      Expanded(
                        child: Center(
                          child: TextGGStyle(
                            StringUtils.formatPrice(
                              amountState.toString(),
                              currency.value ?? 'VND',
                            ),
                            textAlign: TextAlign.center,
                            cc.maxHeight * 0.25,
                            maxLines: 2,
                            fontWeight: FontWeight.bold,
                            color: amountState < 0 ? Colors.red : color,
                          ),
                        ),
                      ),
                      if (amountState < 0)
                        const Icon(Icons.trending_down, color: Colors.red),
                    ],
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
