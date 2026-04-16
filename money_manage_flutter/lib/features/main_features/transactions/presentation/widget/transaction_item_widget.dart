import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/router.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';
import '../../../profile/presentation/provider/currency_provider.dart';
import '../../data/model/local/transaction_local_model.dart';
import '../../domain/usecase/remove_transaction_usecase.dart';
import '../provider/transaction_filter_provider.dart';
import '../provider/transaction_provider.dart';

class TransactionItemWidget extends ConsumerWidget {
  final TransactionLocalModel item;

  const TransactionItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PaddingStyle(
      child: LayoutBuilder(
        builder: (context, cc) {
          Radius radius = Radius.circular(cc.maxHeight * 0.1);
          return RepaintBoundary(
            child: ClipRRect(
              borderRadius: BorderRadius.all(radius),
              child: Slidable(
                key: ValueKey(item.idServer),

                endActionPane: ActionPane(
                  motion: const BehindMotion(),
                  extentRatio: 0.25,
                  children: [
                    Consumer(
                      builder: (context, ref, _) {
                        return SlidableAction(
                          onPressed: (context) async => await _onDelete(),
                          backgroundColor: Colors.red,
                          foregroundColor: ColorConstant.neutral200,
                          icon: Icons.delete,
                          padding: EdgeInsets.zero,
                        );
                      },
                    ),
                  ],
                ),
                child: InkWell(
                  ///Navigate to detail screen
                  onTap: () {
                    NavigatorRouter.pushNamed(
                      context,
                      TransactionsRoutes.editTransactionName,
                      extra: item,
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: context.colorScheme.surface,
                      boxShadow: [
                        shadowStyle(Colors.black54, const Offset(0, 5), 5),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: cc.maxHeight * 0.05,
                        horizontal: cc.maxWidth * 0.025,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                /// Amount
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Consumer(
                                    builder: (context, ref, _) {
                                      final currencyState = ref.watch(
                                        currencyProvider,
                                      );

                                      return currencyState.when(
                                        data: (currency) {
                                          return TextGGStyle(
                                            StringUtils.formatPrice(
                                              item.amount.toString(),
                                              currency,
                                            ),
                                            cc.maxWidth * 0.05,
                                            fontWeight: FontWeight.w600,
                                          );
                                        },
                                        error: (err, stack) {
                                          return TextGGStyle(
                                            err.toString(),
                                            cc.maxWidth * 0.05,
                                          );
                                        },
                                        loading: () => const LoadingWidget(),
                                      );
                                    },
                                  ),
                                ),

                                /// Title
                                TextGGStyle(
                                  item.type.displayTitle(context),
                                  cc.maxWidth * 0.035,
                                  color: item.type.color,
                                  fontWeight: FontWeight.w600,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Align(
                              alignment: Alignment.centerLeft,
                              child: TextGGStyle(
                                item.note,
                                cc.maxWidth * 0.035,
                                color: ColorConstant.neutral400,
                                maxLines: 2,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  child: TextGGStyle(
                                    item.transactionAt.formatDate(context),
                                    cc.maxWidth * 0.035,
                                    color: ColorConstant.neutral400,
                                    maxLines: 2,
                                  ),
                                ),
                                Row(
                                  children: [
                                    if (item.imageUrl != null ||
                                        item.imageBytes != null)
                                      const Icon(
                                        Icons.image,
                                        color: ColorConstant.warning700,
                                      ),
                                    SizedBox(width: cc.maxWidth * 0.025),
                                    Icon(
                                      item.isSynced
                                          ? Icons.cloud
                                          : Icons.downloading_sharp,
                                      color: ColorConstant.warning700,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _onDelete() async {
    BuildContext context = appNavigatorKey.currentState!.context;

    final title = context.lang.transaction_delete_item_title;
    final content = context.lang.transaction_delete_item_content;

    final isConfirmed = await DialogUtils.handleDecision(
      context,
      title: title,
      content: content,
    );

    if (!isConfirmed) return;
    final result = await getIt<RemoveTransactionUseCase>().execute(item);

    result.fold(
      (error) {
        DialogUtils.handleDecision(context, title: error.message);
      },
      (isSuccess) async {
        final container = ProviderScope.containerOf(context, listen: false);
        final syncKey = container.read(transactionFilterProvider);
        final notifier = container.read(
          loadingTransactionProvider(syncKey).notifier,
        );
        await notifier.refresh();
      },
    );
  }
}
