import 'package:go_router/go_router.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../../main_features/transactions/presentation/provider/quick_select_cate_provider.dart';
import '../../data/model/local/category_local_model.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../provider/category_provider.dart';
import '../../domain/usecase/edit_category_usecase.dart';
import '../widget/trans_type_segment_widget.dart';

class EditCategoryScreen extends ConsumerStatefulWidget {
  final CategoryLocalModel item;

  const EditCategoryScreen({super.key, required this.item});

  @override
  ConsumerState<EditCategoryScreen> createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends ConsumerState<EditCategoryScreen> {
  late TextEditingController nameTextController;
  late TextEditingController descTextController;
  late TransactionType selectedType;

  CategoryLocalModel get item => widget.item;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameTextController = TextEditingController(text: item.name);
    descTextController = TextEditingController(text: item.description);

    selectedType = widget.item.type ?? TransactionType.INCOME;
  }

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

    List<Widget> widgets = [
      SizedBox(
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
      SizedBox(
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
      TransTypeSegmentWidget(
        selectedType: selectedType,
        isCanPickType: false,
        updateType: (newTransType) {
          selectedType = newTransType;
        },
      ),
      BtnMainWidget(
        w: sWPadding,
        h: hBtn,
        radius: hBtn * 0.05,
        color: ColorConstant.primary,
        onTap: _onCreatePressed,
        child: TextGGStyle(
          context.lang.update,
          hBtn * 0.4,
          color: Colors.white,
          fontWeight: FontWeight.w600,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBarWidget(
        title: context.lang.category_edit,
        isCentralTitle: true,
      ),
      body: PaddingStyle(
        child: CustomScrollView(
          slivers: [
            for (var widget in widgets) ...[
              SliverToBoxAdapter(child: widget),
              const SliverToBoxAdapter(child: SpacingStyle()),
            ],
          ],
        ),
      ),
    );
  }

  void _onCreatePressed() async {
    final useCase = getIt<EditCategoryUseCase>();

    final result = await useCase.execute(
      widget.item.toUpdateJson(
        nameTemp: nameTextController.text,
        descTemp: descTextController.text,
        typeTemp: selectedType,
      ),
      item,
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
      (updatedCate) {
        /// Update UI
        ref.read(loadingCategoryProvider.notifier).refresh();
        ref.invalidate(quickSelectCategoryProvider(TransactionType.INCOME));
        ref.invalidate(quickSelectCategoryProvider(TransactionType.EXPENSE));

        context.pop();
      },
    );
  }
}
