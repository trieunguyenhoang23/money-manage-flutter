import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../data/model/local/transaction_local_model.dart';
import '../provider/transaction_provider.dart';
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
  late final ProviderSubscription refListener;

  final provider = loadingTransactionProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(provider.notifier);

      // Load lần đầu
      if (notifier.page == 0) {
        notifier.loadMore();
      }

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

    if (state.errorMessage != null && state.visibleList.isEmpty) {
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

    return RefreshIndicator(
      onRefresh: () async {
        await notifier.refresh();
      },
      child: state.visibleList.isEmpty && state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo.metrics.pixels >=
                    scrollInfo.metrics.maxScrollExtent) {
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
                  TransactionLocalModel item = state.visibleList[index];

                  return LayoutBuilder(
                    builder: (context, cc) {
                      return TransactionItemWidget(item: item);
                    },
                  );
                },
                childAspectRatio: 275 / 85,
              ),
            ),
    );
  }
}
