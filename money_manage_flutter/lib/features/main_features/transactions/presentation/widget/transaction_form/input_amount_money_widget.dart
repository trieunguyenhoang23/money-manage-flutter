import 'package:money_manage_flutter/core/extension/context_extension.dart';
import 'package:money_manage_flutter/core/utils/currency_formatter_utils.dart';
import 'package:money_manage_flutter/core/utils/string_utils.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../../data/model/local/transaction_local_model.dart';
import '../../provider/transaction_provider.dart';

class InputAmountMoneyWidget extends HookConsumerWidget {
  final TransactionLocalModel? updateTrans;

  const InputAmountMoneyWidget({super.key, this.updateTrans});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(currentTransactionProvider);

    final amountNotifier = ref.read(provider.notifier);
    final amountState = ref.read(provider.select((s) => s.amount));

    final inputController = useTextEditingController(
      text: StringUtils.formatNumber(amountState.toString()),
    );

    useListenable(inputController);

    double textWidth = inputController.text.length * 15.0;
    double minWidth = 0.4.sw;
    double maxWidth = 0.9.sw;

    double finalWidth = (textWidth + 80.0).clamp(minWidth, maxWidth);

    return Align(
      alignment: Alignment.center,
      child: Container(
        width: finalWidth,
        height: 0.08.sh,
        padding: const EdgeInsets.symmetric(horizontal: 12),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextInputNumberWidget(
                hintText: '0',
                textController: inputController,
                onChange: (value) {
                  final cleanValue = value.replaceAll(RegExp(r'[^0-9]'), '');

                  if (cleanValue.isNotEmpty) {
                    final amount = double.tryParse(cleanValue) ?? 0;
                    amountNotifier.updateAmount(amount);
                  }
                },
                onSubmit: (value) {},
                onClearText: () {},
                validator: (value) {
                  if (value == null || value.isEmpty || value == '0') {
                    return context.lang.transaction_validator_empty_amount;
                  }
                  return null;
                },
              ),
            ),
            SizedBox(width: 0.025.sw),
            TextGGStyle('VND', 0.05.sw, maxLines: 1),
          ],
        ),
      ),
    );
  }
}
