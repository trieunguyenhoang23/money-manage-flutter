import 'package:money_manage_flutter/core/constant/color_constant.dart';
import 'package:money_manage_flutter/core/extension/context_extension.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/features/main_features/transactions/presentation/widget/date_picked_widget.dart';
import 'package:money_manage_flutter/features/main_features/transactions/presentation/widget/input_note_widget.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../widget/category_picked_widget.dart';
import '../widget/input_amount_money_widget.dart';

class CreateTransactionScreen extends StatefulWidget {
  const CreateTransactionScreen({super.key});

  @override
  State<CreateTransactionScreen> createState() =>
      _CreateTransactionScreenState();
}

class _CreateTransactionScreenState extends State<CreateTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  double inputAmount = 0;
  String inputNote = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: context.lang.transaction_create_new),
      body: PaddingStyle(
        child: Form(
          key: _formKey,
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: InputAmountMoneyWidget(
                  onChangeData: (value) {
                    inputAmount = value;
                  },
                ),
              ),
              const SliverToBoxAdapter(child: CategoryPickedWidget()),
              const SliverToBoxAdapter(child: SpacingStyle()),
              SliverToBoxAdapter(
                child: InputNoteWidget(
                  onChangeData: (String note) {
                    inputNote = note;
                  },
                ),
              ),
              const SliverToBoxAdapter(child: SpacingStyle()),
              const SliverToBoxAdapter(child: DatePickedWidget()),

              const SliverToBoxAdapter(child: SpacingStyle()),

              SliverToBoxAdapter(
                child: BtnMainWidget(
                  onTap: () {
                    if (_formKey.currentState!.validate()) {}
                  },
                  color: ColorConstant.primary,
                  child: TextGGStyle(
                    context.lang.create,
                    0.05.sw,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onSaveData() async {}
}
