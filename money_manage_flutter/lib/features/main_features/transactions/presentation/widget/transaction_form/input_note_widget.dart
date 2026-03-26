import 'package:money_manage_flutter/core/extension/context_extension.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../provider/transaction_provider.dart';

class InputNoteWidget extends HookConsumerWidget {
  const InputNoteWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(currentTransactionProvider);
    final inputNoteState = ref.read(provider.select((s) => s.note));
    final inputNoteNotifier = ref.read(provider.notifier);
    final noteController = useTextEditingController(text: inputNoteState);

    return SizedBox(
      width: 1.sw,
      height: 0.2.sh,
      child: LayoutBuilder(
        builder: (context, cc) {
          Widget spacingHeight = SizedBox(height: 0.075 * cc.maxHeight);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextGGStyle(
                context.lang.note,
                (cc.maxHeight * 0.2).clamp(14, 18),
                fontWeight: FontWeight.bold,
              ),
              spacingHeight,
              Expanded(
                child: TextInputEditWidget(
                  hintText: context.lang.note,
                  textController: noteController,
                  onChange: (value) {
                    inputNoteNotifier.updateNote(value);
                  },
                  onSubmit: (value) {},
                  onClearText: () {},
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
