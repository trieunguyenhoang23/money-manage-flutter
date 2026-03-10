import 'package:money_manage_flutter/export/ui_external.dart';
import '../../../main_features/transactions/domain/enums/transaction_type.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/core.dart';

class TransTypeSegmentWidget extends StatefulWidget {
  final TransactionType selectedType;
  final Function(TransactionType newType) updateType;

  const TransTypeSegmentWidget({
    super.key,
    required this.selectedType,
    required this.updateType,
  });

  @override
  State<TransTypeSegmentWidget> createState() => _TransTypeSegmentWidgetState();
}

class _TransTypeSegmentWidgetState extends State<TransTypeSegmentWidget> {
  late TransactionType selectedType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    selectedType = widget.selectedType;
  }

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<TransactionType>(
      segments: [
        ButtonSegment(
          value: TransactionType.INCOME,
          label: TextGGStyle(
            context.lang.income,
            0.03.sw,
            isAutoSizeText: false,
          ),
          icon: const Icon(Icons.add_circle_outline),
        ),
        ButtonSegment(
          value: TransactionType.EXPENSE,
          label: TextGGStyle(
            context.lang.expense,
            0.03.sw,
            isAutoSizeText: false,
          ),
          icon: const Icon(Icons.remove_circle_outline),
        ),
      ],
      selected: {selectedType},
      onSelectionChanged: (Set<TransactionType> newSelection) {
        setState(() {
          selectedType = newSelection.first;
        });
        widget.updateType(newSelection.first);
      },
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: selectedType.color.withValues(alpha: 0.2),
        selectedForegroundColor: selectedType.color,
      ),
    );
  }
}
