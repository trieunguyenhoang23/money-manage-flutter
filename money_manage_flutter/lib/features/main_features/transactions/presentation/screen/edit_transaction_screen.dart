import 'package:go_router/go_router.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../../analytics/presentation/provider/overview_balance_provider.dart';
import '../../data/model/local/transaction_local_model.dart';
import '../provider/transaction_provider.dart';
import '../provider/transaction_update_provider.dart';
import '../widget/transaction_form/category_picked_widget.dart';
import '../widget/transaction_form/date_picked_widget.dart';
import '../widget/transaction_form/image_widget.dart';
import '../widget/transaction_form/input_amount_money_widget.dart';
import '../widget/transaction_form/input_note_widget.dart';
import 'package:money_manage_flutter/export/shared.dart';

class EditTransactionScreen extends ConsumerStatefulWidget {
  final TransactionLocalModel item;

  const EditTransactionScreen({super.key, required this.item});

  @override
  ConsumerState<EditTransactionScreen> createState() =>
      _EditTransactionScreenState();
}

class _EditTransactionScreenState extends ConsumerState<EditTransactionScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final items = [
      InputAmountMoneyWidget(updateTrans: widget.item),
      const CategoryPickedWidget(),
      const InputNoteWidget(),
      const DatePickedWidget(),
      const ImageWidget(),
      _buildSubmitButton(),
    ];

    /// Override to transactionUpdateProvider
    return ProviderScope(
      overrides: [
        currentTransactionProvider.overrideWithValue(
          transactionUpdateProvider(widget.item),
        ),
      ],
      child: Scaffold(
        appBar: AppBarWidget(title: context.lang.transaction_update),
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
      ),
    );
  }

  Widget _buildSubmitButton() {
    return BtnMainWidget(
      onTap: _onCreate,
      color: ColorConstant.primary,
      child: TextGGStyle(
        context.lang.update,
        0.05.sw,
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Future<void> _onCreate() async {
    if (_formKey.currentState!.validate()) {
      DialogUtils.loading(context);
      await ref
          .read(transactionUpdateProvider(widget.item).notifier)
          .submit()
          .then((result) {
            result?.fold(
              (error) {
                /// Pop dialog loading
                context.pop();
                if (error is ValidationFailure) {
                  if (error.code == ValidationCode.notPickCategory) {
                    ToastUtils.showToastFailed(
                      context.lang.transaction_validator_empty_category,
                    );
                  } else if (error.code == ValidationCode.notChangeFormEdit) {
                    ToastUtils.showToastFailed(
                      context.lang.transaction_validator_no_change,
                    );
                  }
                }
              },
              (updateTransaction) {
                ref.invalidate(loadingTransactionProvider);
                // ref
                //     .read(loadingTransactionProvider.notifier)
                //     .updateItem(
                //       (item) => item.idServer == updateTransaction.idServer,
                //       updateTransaction,
                //     );


                /// Refresh Overview Balance to update new data
                ref.refresh(overviewBalanceProvider);

                /// Pop until reaching main screen & switch to transaction tab
                NavigatorRouter.popAndSwitchTabMainBranch(context, 0);
              },
            );
          });
    }
  }
}
