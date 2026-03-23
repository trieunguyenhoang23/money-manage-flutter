import 'package:money_manage_flutter/core/constant/color_constant.dart';
import 'package:money_manage_flutter/core/extension/date_extension.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../provider/transaction_form_provider.dart';

class DatePickedWidget extends ConsumerWidget {
  const DatePickedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateState = ref.watch(
      transactionFormProvider.select((s) => s.transactionAt),
    );
    final dateNotifier = ref.read(transactionFormProvider.notifier);

    return StatefulBuilder(
      builder: (context, ss) {
        return InkWell(
          onTap: () async {
            final DateTime? datePicked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );

            if (datePicked != null) {
              ss(() {
                dateNotifier.updateDate(datePicked);
              });
            }
          },
          child: SizedBox(
            height: 0.05.sh,
            child: Row(
              children: [
                const Icon(Icons.calendar_month, color: ColorConstant.primary),
                SizedBox(width: 0.05.sw),
                TextGGStyle(dateState.formatDate(context), 0.04.sw),
              ],
            ),
          ),
        );
      },
    );
  }
}
