import 'package:money_manage_flutter/core/constant/color_constant.dart';
import 'package:money_manage_flutter/core/extension/date_extension.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';

class DatePickedWidget extends StatelessWidget {
  const DatePickedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    DateTime pickDate = DateTime.now();

    return StatefulBuilder(
      builder: (context, ss) {
        return InkWell(
          onTap: () async {
            final DateTime? picked = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime.now(),
            );
            if (picked != null) {
              ss(() {
                pickDate = picked;
              });
            }
          },
          child: SizedBox(
            height: 0.05.sh,
            child: Row(
              children: [
                const Icon(Icons.calendar_month, color: ColorConstant.primary),
                SizedBox(width: 0.05.sw),
                TextGGStyle(pickDate.formatDate(context), 0.04.sw),
              ],
            ),
          ),
        );
      },
    );
  }
}
