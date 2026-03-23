import 'package:go_router/go_router.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../provider/transaction_form_provider.dart';
import '../provider/transaction_provider.dart';
import '../widget/transaction_form/category_picked_widget.dart';
import '../widget/transaction_form/date_picked_widget.dart';
import '../widget/transaction_form/image_widget.dart';
import '../widget/transaction_form/input_amount_money_widget.dart';
import '../widget/transaction_form/input_note_widget.dart';

class CreateTransactionScreen extends ConsumerStatefulWidget {
  const CreateTransactionScreen({super.key});

  @override
  ConsumerState<CreateTransactionScreen> createState() =>
      _CreateTransactionScreenState();
}

class _CreateTransactionScreenState
    extends ConsumerState<CreateTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final items = [
      const InputAmountMoneyWidget(),
      const CategoryPickedWidget(),
      const InputNoteWidget(),
      const DatePickedWidget(),
      const ImageWidget(),
      _buildSubmitButton(),
    ];

    return Scaffold(
      appBar: AppBarWidget(title: context.lang.transaction_create_new),
      body: PaddingStyle(
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              for (var item in items) ...[
                const SliverToBoxAdapter(child: SpacingStyle()),
                SliverToBoxAdapter(child: item),
              ],
              const SliverToBoxAdapter(child: SpacingStyle()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BtnMainWidget(
      onTap: () async {
        if (_formKey.currentState!.validate()) {
          DialogUtils.loading(context);
          await ref.read(transactionFormProvider.notifier).submit().then((
            result,
          ) {
            if (result == null) {
              if (mounted) {
                ToastUtils.showToastFailed(
                  context.lang.transaction_validator_empty_category,
                );

                /// Pop dialog loading
                context.pop();
              }
              return;
            }

            result.fold(
              (error) {
                /// Pop dialog loading
                context.pop();
                ToastUtils.showToastFailed(error.message);
              },
              (transactionLocal) {
                ref
                    .read(loadingTransactionProvider.notifier)
                    .addToFirst(transactionLocal);

                /// Pop until reaching main screen & switch to transaction tab
                NavigatorRouter.popAndSwitchTabMainBranch(context, 0);
              },
            );
          });
        }
      },
      color: ColorConstant.primary,
      child: TextGGStyle(
        context.lang.create,
        0.05.sw,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
