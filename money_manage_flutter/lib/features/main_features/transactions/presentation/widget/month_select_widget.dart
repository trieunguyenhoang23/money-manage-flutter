import 'package:intl/intl.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../data/datasource/sync/transaction_sync_key.dart';
import '../provider/transaction_filter_provider.dart';

class MonthSelectWidget extends ConsumerWidget implements PreferredSizeWidget {
  const MonthSelectWidget({super.key});

  @override
  Size get preferredSize => Size.fromHeight(0.065.sh);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. Theo dõi filter hiện tại
    final currentFilter = ref.watch(transactionFilterProvider);

    return Container(
      height: preferredSize.height,
      padding: const EdgeInsets.only(bottom: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 12,
        itemBuilder: (context, index) {
          final monthValue = index + 1;
          final monthName = DateFormat(
            'MMM',
            Localizations.localeOf(context).languageCode,
          ).format(DateTime(currentFilter.year, monthValue));

          return MonthItemWidget(
            month: monthName,
            isSelected: currentFilter.month == monthValue,
            onTap: () {
              ref
                  .read(transactionFilterProvider.notifier)
                  .update(
                    (state) => TransactionSyncKey(
                      year: state.year,
                      month: monthValue,
                      type: state.type,
                    ),
                  );
            },
          );
        },
      ),
    );
  }
}

class MonthItemWidget extends StatelessWidget {
  final String month;
  final bool isSelected;
  final VoidCallback onTap;

  const MonthItemWidget({
    super.key,
    required this.month,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double itemHeight = 0.05.sh;
    final double itemWidth = 0.175.sw;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: itemWidth,
        margin: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? ColorConstant.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(itemHeight * 0.3),
        ),
        child: Center(
          child: TextGGStyle(
            month,
            itemHeight * 0.35, // Font size dựa trên itemHeight
            color: isSelected ? Colors.white : Colors.grey,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
