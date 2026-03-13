import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/core.dart';

class YearSelectWidget extends ConsumerStatefulWidget {
  const YearSelectWidget({super.key});

  @override
  ConsumerState<YearSelectWidget> createState() => _YearSelectWidgetState();
}

class _YearSelectWidgetState extends ConsumerState<YearSelectWidget> {
  int selectedYear = DateTime.now().year;

  final List<int> years = List.generate(
    20,
    (index) => (DateTime.now().year) - index,
  );

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DropdownButton<int>(
        value: selectedYear,
        underline: const SizedBox(),
        icon: const Icon(Icons.arrow_drop_down, color: ColorConstant.primary),
        items: years.map((int year) {
          return DropdownMenuItem<int>(
            value: year,
            child: TextGGStyle(
              year.toString(),
              0.04.sw.clamp(14, 18),
              fontWeight: FontWeight.bold,
            ),
          );
        }).toList(),
        onChanged: (value) {
          if (value != null) setState(() => selectedYear = value);
        },
      ),
    );
  }
}

