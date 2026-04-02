import 'package:hooks_riverpod/legacy.dart';
import '../../../../../export/ui_external.dart';

final dateRangeProvider = StateProvider<DateTimeRange>((ref) {
  return DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );
});
