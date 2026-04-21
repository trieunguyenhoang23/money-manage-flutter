import 'package:flutter/foundation.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';
import '../provider/date_range_provider.dart';

class DateRangePickWidget extends ConsumerWidget {
  const DateRangePickWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRangeState = ref.watch(dateRangeProvider);
    final dateRangeNotifier = ref.read(dateRangeProvider.notifier);

    if (kDebugMode) {
      print('Date start ${dateRangeState.start.formatServerStart}');
      print('Date end ${dateRangeState.end.formatServerEnd}');
    }

    return InkWell(
      onTap: () async {
        final DateTimeRange? picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2020),
          lastDate: DateTime.now(),
          initialDateRange: dateRangeState,
        );

        if (picked != null) {
          dateRangeNotifier.state = picked;
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.date_range, color: ColorConstant.primary),
          SizedBox(width: 0.025.sw),
          TextGGStyle(
            dateRangeState.formatDateRange(context),
            0.04.sw.clamp(15, 25),
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
