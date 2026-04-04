import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../data/datasource/sync/transaction_sync_key.dart';
import '../provider/transaction_filter_provider.dart';

class YearSelectWidget extends ConsumerWidget {
  const YearSelectWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(transactionFilterProvider);

    final List<int> years = List.generate(
      20,
      (index) => DateTime.now().year - index,
    );

    return Center(
      child: DropdownButton<int>(
        value: currentFilter.year,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down, color: ColorConstant.primary),
        items: years
            .map(
              (year) => DropdownMenuItem<int>(
                value: year,
                child: TextGGStyle(
                  year.toString(),
                  16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
            .toList(),
        onChanged: (value) {
          if (value != null) {
            ref
                .read(transactionFilterProvider.notifier)
                .update(
                  (state) => TransactionSyncKey(
                    year: value,
                    month: state.month,
                    type: state.type,
                  ),
                );
          }
        },
      ),
    );
  }
}
