import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../data/model/local/category_local_model.dart';
import '../category_routes.dart';
import 'category_item_widget.dart';
import 'package:hooks_riverpod/legacy.dart';

class CategoryGridViewWidget extends ConsumerStatefulWidget {
  final StateNotifierProvider<
    PullToRefreshNotifier<CategoryLocalModel>,
    PullToRefreshState<CategoryLocalModel>
  >
  provider;

  final bool isPickedCate;

  const CategoryGridViewWidget({
    super.key,
    required this.provider,
    this.isPickedCate = false,
  });

  @override
  ConsumerState<CategoryGridViewWidget> createState() =>
      _CategoryGridViewWidgetState();
}

class _CategoryGridViewWidgetState
    extends ConsumerState<CategoryGridViewWidget> {
  ScrollController scrollController = ScrollController();
  late final ProviderSubscription refListener;

  get provider => widget.provider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Listen animation list change
      refListener = ref.listenManual(provider, (prev, next) {
        final prevList = (prev as dynamic)?.visibleList as List? ?? [];
        final nextList = (next as dynamic).visibleList as List;

        if (prevList.isNotEmpty && nextList.length > prevList.length) {
          updateAnimationLastItem(
            prevList,
            nextList,
            scrollController: scrollController,
          );
        }
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    scrollController.dispose();
    refListener.close();
  }

  @override
  Widget build(BuildContext context) {
    final notifier = ref.read(provider.notifier);
    final state = ref.watch(provider);

    double wBtn = 0.4.sw;

    double hBtn = wBtn * 75 / 319;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (state.visibleList.isEmpty &&
          !state.isLoading &&
          state.errorMessage == null &&
          notifier.page == 0) {
        notifier.loadMore();
      }
    });

    if (state.errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextGGStyle("${state.errorMessage}", hBtn * 0.3),
            const SizedBox(height: 16),
            BtnMainWidget(
              w: wBtn,
              h: hBtn,
              onTap: () => ref.read(provider.notifier).loadMore(),
              color: ColorConstant.primary,
              radius: hBtn * 0.05,
              child: TextGGStyle(context.lang.retry, hBtn * 0.4),
            ),
          ],
        ),
      );
    }

    if (state.visibleList.isEmpty) {
      if (!state.isLoading) {
        return Center(
          child: BtnMainWidget(
            onTap: () {
              NavigatorRouter.pushNamed(
                context,
                CategoryRoutes.createNewCateName,
              );
            },
            w: 0.1.sw,
            h: 0.1.sw,
            color: ColorConstant.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      }
      return const Center(child: LoadingWidget());
    }

    return RefreshIndicator(
      onRefresh: () async {
        await notifier.refresh();
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              notifier.loadMore();
            });
          }
          return false;
        },
        child: GridViewBuilder(
          scrollController: scrollController,
          crossAxisCount: SizeAppUtils().isTablet ? 2 : 1,
          itemCount: state.visibleList.length,
          itemBuilder: (context, index) {
            CategoryLocalModel item = state.visibleList[index];

            return InkWell(
              onTap: () {
                if (widget.isPickedCate) {
                  /// Return data
                  Navigator.pop(context, item);
                } else {
                  NavigatorRouter.pushNamed(
                    context,
                    CategoryRoutes.editCateName,
                    extra: item,
                  );
                }
              },
              child: CategoryItemWidget(item: item),
            );
          },
          childAspectRatio: 275 / 85,
        ),
      ),
    );
  }
}
