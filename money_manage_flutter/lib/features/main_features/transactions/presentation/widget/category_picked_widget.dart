import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../../../category/data/model/local/category_local_model.dart';
import '../../../../category/presentation/provider/category_provider.dart';
import '../../../../category/presentation/widget/category_grid_view_widget.dart';
import '../provider/transaction_provider.dart';

class CategoryPickedWidget extends HookConsumerWidget {
  const CategoryPickedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabController = useTabController(initialLength: 2);

    final incomeCategoriesAsync = ref.watch(
      quickSelectCategoryProvider(TransactionType.INCOME),
    );
    final expenseCategoriesAsync = ref.watch(
      quickSelectCategoryProvider(TransactionType.EXPENSE),
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
                    _buildCategoryGrid(
                      ref,
                      incomeCategoriesAsync,
                      TransactionType.INCOME,
                    ),
                    _buildCategoryGrid(
                      ref,
                      expenseCategoriesAsync,
                      TransactionType.EXPENSE,
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

  void _showAllCategories(
    BuildContext context,
    TransactionType type,
    WidgetRef ref,
    AsyncValue<List<CategoryLocalModel>> asyncCategories,
  ) async {
    final catePick = await showModalBottomSheet<CategoryLocalModel>(
      context: context,
      backgroundColor: Colors.white,
      builder: (context) {
        return PaddingStyle(
          child: CategoryGridViewWidget(
            provider: loadingCategoryByTypeProvider(type),
            isPickedCate: true,
          ),
        );
      },
    );

    if (catePick != null) {
      ref.read(selectedCategoryProvider.notifier).state = catePick;
      ref
          .read(quickSelectCategoryProvider(type).notifier)
          .addCategory(catePick);
    }
  }

  Widget _buildCategoryGrid(
    WidgetRef ref,
    AsyncValue<List<CategoryLocalModel>> asyncCategories,
    TransactionType type,
  ) {
    final selectedCategory = ref.watch(selectedCategoryProvider);
    return asyncCategories.when(
      loading: () => const Center(child: LoadingWidget()),
      error: (e, st) => Center(child: Text(e.toString())),
      data: (categories) => GridView.builder(
        scrollDirection: Axis.horizontal,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: SizeAppUtils().isTablet ? 3 : 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1 / 2,
        ),
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          final isFirstItem = index == 0;

          if (isFirstItem) {
            return _CategoryItem(
              category: null,
              isAddItem: true,
              onTap: () =>
                  _showAllCategories(context, type, ref, asyncCategories),
            );
          }
          final item = categories[index - 1];
          final isSelected = selectedCategory?.idServer == item.idServer;
          return _CategoryItem(
            category: item,
            isAddItem: false,
            isSelected: isSelected,
            onTap: () {
              ref.read(selectedCategoryProvider.notifier).state = item;
            },
          );
        },
      ),
    );
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
