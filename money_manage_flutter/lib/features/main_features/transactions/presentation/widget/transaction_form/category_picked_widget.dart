import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../../../../category/data/model/local/category_local_model.dart';
import '../../../../../category/presentation/provider/category_provider.dart';
import '../../../../../category/presentation/widget/category_grid_view_widget.dart';
import '../../provider/transaction_form_provider.dart';

class CategoryPickedWidget extends HookConsumerWidget {
  const CategoryPickedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);

    final selectedCategory = ref.watch(
      transactionFormProvider.select((s) => s.category),
    );

    return SizedBox(
      height: 0.25.sh,
      child: LayoutBuilder(
        builder: (context, cc) {
          Widget spacingHeight = SizedBox(height: 0.075 * cc.maxHeight);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextGGStyle(
                context.lang.category,
                (cc.maxHeight * 0.2).clamp(14, 18),
                fontWeight: FontWeight.bold,
              ),
              spacingHeight,
              TabBarWidget(
                tabController: tabController,
                listType: [context.lang.income, context.lang.expense],
              ),
              spacingHeight,
              Expanded(
                child: TabBarView(
                  controller: tabController,
                  children: [
                    _CategoryGridSection(
                      type: TransactionType.INCOME,
                      tabController: tabController,
                      selectedId: selectedCategory?.idServer,
                    ),
                    _CategoryGridSection(
                      type: TransactionType.EXPENSE,
                      tabController: tabController,
                      selectedId: selectedCategory?.idServer,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryGridSection extends ConsumerWidget {
  final TransactionType type;
  final TabController tabController;
  final String? selectedId;

  const _CategoryGridSection({
    required this.type,
    required this.tabController,
    this.selectedId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(quickSelectCategoryProvider(type));

    return categoriesAsync.when(
      loading: () => const Center(child: LoadingWidget()),
      error: (e, st) => Center(child: Text(e.toString())),
      data: (categories) => GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: SizeAppUtils().isTablet ? 3 : 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 0.5,
        ),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _CategoryItem(
              isAddItem: true,
              onTap: () => _handlePickCategory(context, ref),
            );
          }
          final item = categories[index - 1];
          return _CategoryItem(
            category: item,
            isSelected: selectedId == item.idServer,
            onTap: () =>
                ref.read(transactionFormProvider.notifier).updateCategory(item),
          );
        },
      ),
    );
  }

  void _handlePickCategory(BuildContext context, WidgetRef ref) async {
    final catePick = await showModalBottomSheet<CategoryLocalModel>(
      context: context,
      builder: (context) => PaddingStyle(
        isVerticalPadding: true,
        child: CategoryGridViewWidget(
          provider: loadingCategoryProvider,
          isPickedCate: true,
        ),
      ),
    );

    if (catePick != null) {
      final notifier = ref.read(transactionFormProvider.notifier);
      notifier.updateCategory(catePick);

      // Cập nhật danh sách chọn nhanh
      final type = catePick.type ?? TransactionType.EXPENSE;
      ref
          .read(quickSelectCategoryProvider(type).notifier)
          .addCategory(catePick);

      // Chuyển tab nếu cần
      tabController.animateTo(type == TransactionType.INCOME ? 0 : 1);
    }
  }
}

class _CategoryItem extends StatelessWidget {
  final CategoryLocalModel? category;
  final bool isAddItem;
  final bool isSelected;
  final Function() onTap;

  const _CategoryItem({
    this.category,
    this.isAddItem = false,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cc) {
        return InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? ColorConstant.primary
                  : ColorConstant.neutral200,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: isAddItem
                ? const Icon(Icons.add)
                : TextGGStyle(
                    category?.name ?? '',
                    cc.maxWidth * 0.1,
                    maxLines: 1,
                  ),
          ),
        );
      },
    );
  }
}
