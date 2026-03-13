import 'package:intl/intl.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/core.dart';

class MonthSelectWidget extends StatefulWidget implements PreferredSizeWidget {
  const MonthSelectWidget({super.key});

  @override
  State<MonthSelectWidget> createState() => _MonthSelectWidgetState();

  @override
  Size get preferredSize => Size.fromHeight(0.065.sh);
}

class _MonthSelectWidgetState extends State<MonthSelectWidget> {
  // 3. Move selection state here so it persists and triggers UI updates
  int selectedMonth = DateTime.now().month - 1;
  int selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.preferredSize.height,
      padding: const EdgeInsets.only(bottom: 10),
      // Background color if needed to match AppBar
      color: Colors.transparent,
      child: GridViewBuilder(
        isScrollHorizontal: true,
        crossAxisCount: 1,
        itemCount: 12,
        itemBuilder: (context, index) {
          // 4. Localized Month Names
          final monthName = DateFormat(
            'MMM',
            Localizations.localeOf(context).languageCode,
          ).format(DateTime(selectedYear, index + 1));

          return MonthItemWidget(
            month: monthName,
            isSelected: selectedMonth == index,
            onTap: () {
              setState(() {
                selectedMonth = index;
              });
              // TODO: Call your Riverpod/Provider notifier here
            },
          );
        },
        childAspectRatio: 4 / 6,
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
    return LayoutBuilder(
      builder: (context, cc) {
        return GestureDetector(
          onTap: onTap,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: cc.maxWidth * 0.01),
            decoration: BoxDecoration(
              color: isSelected ? ColorConstant.primary : Colors.transparent,
              borderRadius: BorderRadius.circular(cc.maxHeight * 0.4),
            ),
            child: Center(
              child: TextGGStyle(
                month,
                cc.maxHeight * 0.3,
                color: isSelected ? Colors.white : Colors.grey,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }
}
