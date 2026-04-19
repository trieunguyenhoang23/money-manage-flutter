import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../../../../category/data/model/local/category_local_model.dart';
import '../../../../../category/presentation/provider/category_provider.dart';
import '../../../../../category/presentation/widget/category_grid_view_widget.dart';
import '../../provider/base_transaction_provider.dart';
import '../../provider/quick_select_cate_provider.dart';
import '../../provider/transaction_provider.dart';

class CategoryPickedWidget<T extends BaseTransactionState>
    extends HookConsumerWidget {
  const CategoryPickedWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(currentTransactionProvider);
    final cateState = ref.read(provider.select((s) => s.category));
    final type = cateState != null ? cateState.type : TransactionType.INCOME;
    final initTab = type == TransactionType.INCOME ? 0 : 1;

    final tabController = useTabController(
      initialLength: 2,
      initialIndex: initTab,
    );

    return SizedBox(
      height: 0.25.sh.clamp(75, 200),
      child: LayoutBuilder(
        builder: (context, cc) {
          Widget spacingHeight = SizedBox(height: 0.1 * cc.maxHeight);

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextGGStyle(
                context.lang.category,
                (cc.maxHeight * 0.2).clamp(14, 18),
                fontWeight: FontWeight.bold,
              ),
              spacingHeight,
              Center(
                child: TabBarWidget(
                  tabController: tabController,
                  listType: [context.lang.income, context.lang.expense],
                ),
              ),
              spacingHeight,
              Expanded(
                child: Consumer(
                  builder: (context, ref, _) {
                    return TabBarView(
                      controller: tabController,
                      children: [
                        _CategoryGridSection(
                          type: TransactionType.INCOME,
                          tabController: tabController,
                        ),
                        _CategoryGridSection(
                          type: TransactionType.EXPENSE,
                          tabController: tabController,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _CategoryGridSection<T extends BaseTransactionState>
    extends ConsumerWidget {
  final TransactionType type;
  final TabController tabController;

  const _CategoryGridSection({required this.type, required this.tabController});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(quickSelectCategoryProvider(type));

    return categoriesAsync.when(
      loading: () => const Center(child: LoadingWidget()),
      error: (e, st) => Center(child: Text(e.toString())),
      data: (categories) => GridViewBuilder(
        isScrollHorizontal: true,
        crossAxisCount: 2,
        mainAxisSpacing: SizeAppUtils().isTablet ? 20 : 10,
        crossAxisSpacing: SizeAppUtils().isTablet ? 20 : 10,
        itemCount: categories.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return _CategoryItem(
              isAddItem: true,
              onTap: () => _handlePickCategory(context, ref),
            );
          }

          final item = categories[index - 1];
          return _CategoryGridItemWrapper(item: item);
        },
        childAspectRatio: 0.5,
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
      final provider = ref.read(currentTransactionProvider);
      final notifier = ref.read(provider.notifier);
      notifier.updateCategory(catePick);

      final type = catePick.type ?? TransactionType.EXPENSE;
      ref
          .read(quickSelectCategoryProvider(type).notifier)
          .addCategoryIfNeeded(catePick);

      // Chuyển tab nếu cần
      tabController.animateTo(type == TransactionType.INCOME ? 0 : 1);
    }
  }
}

class _CategoryGridItemWrapper<T extends BaseTransactionState>
    extends ConsumerWidget {
  final CategoryLocalModel item;

  const _CategoryGridItemWrapper({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final provider = ref.read(currentTransactionProvider);
    final isSelected = ref.watch(
      provider.select((state) => state.category?.idServer == item.idServer),
    );

    final notifier = ref.read(provider.notifier);

    return _CategoryItem(
      category: item,
      isSelected: isSelected,
      onTap: () => notifier.updateCategory(item),
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
                  : context.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: isAddItem
                ? const Icon(Icons.add)
                : Padding(
                    padding: EdgeInsets.all(cc.maxWidth * 0.1),
                    child: TextGGStyle(
                      category?.name ?? '',
                      cc.maxWidth * 0.1,
                      maxLines: 2,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
