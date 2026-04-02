import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';
import '../provider/cate_analytics_provider.dart';

class DateRangePickWidget extends ConsumerWidget {
  const DateRangePickWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dateRangeState = ref.watch(analyticsDateRangeProvider);
    final dateRangeNotifier = ref.read(analyticsDateRangeProvider.notifier);

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
            0.04.sw,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
