import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../provider/transaction_filter_provider.dart';

class TransactionFilterWidget extends ConsumerWidget {
  const TransactionFilterWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double textSize = 0.035.sw.clamp(10, 20);
    final currentFilter = ref.watch(transactionFilterProvider);

    return PopupMenuButton<TransactionType?>(
      initialValue: currentFilter.type,
      icon: const Icon(Icons.filter_list),
      onSelected: (TransactionType? type) {
        ref
            .read(transactionFilterProvider.notifier)
            .update((state) => state.copyWith(type: type));
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: null,
          child: TextGGStyle(context.lang.all, textSize, isAutoSizeText: false),
          onTap: () {
            ref
                .read(transactionFilterProvider.notifier)
                .update((state) => state.copyWith(type: null));
          },
        ),
        PopupMenuItem(
          value: TransactionType.EXPENSE,
          child: TextGGStyle(
            context.lang.expense,
            textSize,
            isAutoSizeText: false,
          ),
        ),
        PopupMenuItem(
          value: TransactionType.INCOME,
          child: TextGGStyle(
            context.lang.income,
            textSize,
            isAutoSizeText: false,
          ),
        ),
      ],
    );
  }
}
