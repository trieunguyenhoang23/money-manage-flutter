import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/core.dart';

class TransTypeSegmentWidget extends StatefulWidget {
  final TransactionType selectedType;
  final bool isCanPickType;
  final Function(TransactionType newType) updateType;

  const TransTypeSegmentWidget({
    super.key,
    required this.selectedType,
    required this.updateType,
    this.isCanPickType = true,
  });

  @override
  State<TransTypeSegmentWidget> createState() => _TransTypeSegmentWidgetState();
}

class _TransTypeSegmentWidgetState extends State<TransTypeSegmentWidget> {
  late TransactionType selectedType;

  @override
  void initState() {
    super.initState();
    selectedType = widget.selectedType;
  }

  @override
  Widget build(BuildContext context) {
    final allSegments = [
      (
        type: TransactionType.INCOME,
        label: context.lang.income,
        icon: Icons.add_circle_outline,
      ),
      (
        type: TransactionType.EXPENSE,
        label: context.lang.expense,
        icon: Icons.remove_circle_outline,
      ),
    ];

    return SegmentedButton<TransactionType>(
      segments: allSegments
          .where((s) => widget.isCanPickType || s.type == selectedType)
          .map(
            (s) => ButtonSegment(
              value: s.type,
              label: TextGGStyle(s.label, 0.025.sw, isAutoSizeText: false),
              icon: Icon(s.icon),
            ),
          )
          .toList(),
      selected: {selectedType},
      onSelectionChanged: widget.isCanPickType
          ? (newSelection) {
              setState(() => selectedType = newSelection.first);
              widget.updateType(newSelection.first);
            }
          : null,
      style: SegmentedButton.styleFrom(
        textStyle: TextStyle(fontSize: 0.025.sw, fontWeight: FontWeight.w600),
        iconSize: 0.05.sw,
        padding: EdgeInsets.all(0.02.sw),
        selectedBackgroundColor: selectedType.color.withValues(alpha: 0.2),
        selectedForegroundColor: selectedType.color,
        disabledBackgroundColor: selectedType.color.withValues(alpha: 0.2),
        disabledForegroundColor: selectedType.color,
        side: BorderSide(
          color: selectedType.color.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
    );
  }
}
