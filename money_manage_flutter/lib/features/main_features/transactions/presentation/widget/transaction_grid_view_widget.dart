import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../data/model/local/transaction_local_model.dart';
import '../provider/transaction_filter_provider.dart';
import '../provider/transaction_provider.dart';
import '../transaction_routes.dart';
import 'transaction_item_widget.dart';

class TransactionGridViewWidget extends ConsumerStatefulWidget {
  const TransactionGridViewWidget({super.key});

  @override
  ConsumerState<TransactionGridViewWidget> createState() =>
      _TransactionGridViewWidgetState();
}

class _TransactionGridViewWidgetState
    extends ConsumerState<TransactionGridViewWidget> {
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Tracking current filter (Year/Month/Type)
    final syncKey = ref.watch(transactionFilterProvider);

    // Point to the correct provider
    final currentProvider = loadingTransactionProvider(syncKey);

    final state = ref.watch(currentProvider);
    final notifier = ref.read(currentProvider.notifier);

    ref.listen(currentProvider, (prev, next) {
      if (prev == null) return;
      if (next.visibleList.length > prev.visibleList.length &&
          notifier.page > 1) {
        updateAnimationLastItem(
          prev.visibleList,
          next.visibleList,
          scrollController: scrollController,
        );
      }
    });

    // Automatically load the first time if there is no data yet
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      if (state.visibleList.isEmpty &&
          !state.isLoading &&
          state.errorMessage == null &&
          notifier.page == 0) {
        notifier.loadMore();
      }
    });

    double wBtn = 0.4.sw;
    double hBtn = wBtn * 75 / 319;

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
              onTap: () => notifier.loadMore(),
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
                TransactionsRoutes.createNewTransactionName,
              );
            },
            w: 0.1.sw,
            h: 0.1.sw,
            color: ColorConstant.primary,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        );
      }

      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async {
        notifier.refresh();
      },
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!state.isLoading && state.visibleList.isNotEmpty) {
                Future.microtask(() => notifier.loadMore());
              }
            });
          }
          return false;
        },
        child: GridViewBuilder(
          scrollController: scrollController,
          crossAxisCount: SizeAppUtils().isTablet ? 2 : 1,
          itemCount: state.visibleList.length,
          itemBuilder: (context, index) {
            TransactionLocalModel item = state.visibleList[index];

            return LayoutBuilder(
              builder: (context, cc) {
                return TransactionItemWidget(item: item);
              },
            );
          },
          childAspectRatio: 4,
        ),
      ),
    );
  }
}
