import 'package:flutter/foundation.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../provider/transaction_provider.dart';

class DatePickedWidget extends ConsumerWidget {
  const DatePickedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(currentTransactionProvider);
    final dateNotifier = ref.read(provider.notifier);
    final dateState = ref.read(provider.select((s) => s.transactionAt));
    DateTime datePicked = dateState;

    return StatefulBuilder(
      builder: (context, ss) {
        return InkWell(
          onTap: () async {
            final DateTime? datePickedTemp = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );

            if (datePickedTemp != null) {
              ss(() {
                datePicked = datePickedTemp;
              });
              dateNotifier.updateDate(datePicked);
            }
          },
          child: SizedBox(
            height: 0.05.sh,
            child: Row(
              children: [
                const Icon(Icons.calendar_month, color: ColorConstant.primary),
                SizedBox(width: 0.05.sw),
                TextGGStyle(datePicked.formatDate(context), 0.04.sw),
              ],
            ),
          ),
        );
      },
    );
  }
}
