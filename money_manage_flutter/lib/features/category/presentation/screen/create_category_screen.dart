import 'package:go_router/go_router.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../../../core/di/injection.dart';
import '../../../../core/enum/transaction_type.dart';
import '../../domain/usecase/create_category_usecase.dart';
import '../provider/category_provider.dart';
import '../widget/trans_type_segment_widget.dart';

class CreateCategoryScreen extends ConsumerStatefulWidget {
  const CreateCategoryScreen({super.key});

  @override
  ConsumerState<CreateCategoryScreen> createState() =>
      _CreateCategoryScreenState();
}

class _CreateCategoryScreenState extends ConsumerState<CreateCategoryScreen> {
  TextEditingController nameTextController = TextEditingController();
  TextEditingController descTextController = TextEditingController();
  TransactionType selectedType = TransactionType.EXPENSE;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameTextController.dispose();
    descTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double sWPadding = SizeAppUtils().wScreenWithPadding;

    double hNameField = (sWPadding * 34 / 150).clamp(44, 100);
    double hDescField = (sWPadding * 60 / 200).clamp(100, 250);

    double hBtn = sWPadding * 43 / 319;

    return Scaffold(
      appBar: AppBarWidget(
        title: context.lang.category_create_new,
        isCentralTitle: true,
      ),
      body: PaddingStyle(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: hNameField,
                child: TextInputEditWidget(
                  hintText: context.lang.name,
                  textController: nameTextController,
                  maxLength: 50,
                  onChange: (value) {},
                  onSubmit: (value) {},
                  onClearText: () {},
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SpacingStyle()),
            SliverToBoxAdapter(
              child: SizedBox(
                height: hDescField,
                child: TextInputEditWidget(
                  hintText: context.lang.description,
                  textController: descTextController,
                  maxLength: 200,
                  onChange: (value) {},
                  onSubmit: (value) {},
                  onClearText: () {},
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SpacingStyle()),
            SliverToBoxAdapter(
              child: TransTypeSegmentWidget(
                selectedType: selectedType,
                updateType: (newTransType) {
                  selectedType = newTransType;
                },
              ),
            ),
            const SliverToBoxAdapter(child: SpacingStyle()),
            SliverToBoxAdapter(
              child: BtnMainWidget(
                w: sWPadding,
                h: hBtn,
                radius: hBtn * 0.05,
                color: ColorConstant.primary,
                onTap: _onCreatePressed,
                child: TextGGStyle(
                  context.lang.create,
                  hBtn * 0.4,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onCreatePressed() async {
    final useCase = getIt<CreateCategoryUseCase>();

    final result = await useCase.execute(
      nameTextController.text,
      descTextController.text,
      selectedType,
    );

    result.fold(
      (failure) {
        String message = context.lang.category_error_server;

        if (failure is ValidationFailure) {
          message = switch (failure.code) {
            ValidationCode.nameTooShort =>
              context.lang.category_error_name_short,
            ValidationCode.descriptionEmpty =>
              context.lang.category_error_desc_empty,
            _ => message,
          };
        }

        // Show toast
        ToastUtils.showToastFailed(message);
      },
      (newCate) {
        /// Add new item
        ref.read(loadingCategoryProvider.notifier).addToFirst(newCate);
        context.pop();
      },
    );
  }
}
