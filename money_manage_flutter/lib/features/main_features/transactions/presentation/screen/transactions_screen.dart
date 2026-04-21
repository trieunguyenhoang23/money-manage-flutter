import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/router.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../../../../shared/widget/btn/btn_floating_widget.dart';
import '../widget/month_select_widget.dart';
import '../widget/transaction_filter_widget.dart';
import '../widget/transaction_grid_view_widget.dart';
import '../widget/year_select_widget.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ExtendedNestedScrollView(
          onlyOneScrollInBody: true,
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              /// Calculate header overlap height
              SliverOverlapAbsorber(
                handle: ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
                sliver: SliverAppBar(
                  pinned: true,
                  floating: false,
                  titleSpacing: 0,
                  title: SizedBox(
                    width: 1.sw,
                    child: const Stack(
                      alignment: Alignment.center,
                      children: [
                        YearSelectWidget(),
                        Positioned(right: 0, child: TransactionFilterWidget()),
                      ],
                    ),
                  ),
                  bottom: const MonthSelectWidget(),
                  centerTitle: false,
                  toolbarHeight: (158 / 375).sw.clamp(0, 207) * 35 / 158 + 10,
                  automaticallyImplyLeading: false,
                ),
              ),
            ];
          },
          body: Builder(
            builder: (context) {
              return CustomScrollView(
                slivers: [
                  /// Receive input from SliverOverlapAbsorber and creating padding space with a height
                  /// exactly equal to the height of appbar
                  SliverOverlapInjector(
                    handle:
                        ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(
                          context,
                        ),
                  ),
                  const SliverToBoxAdapter(child: SpacingStyle()),
                  const SliverFillRemaining(
                    child: KeepAliveWidget(child: TransactionGridViewWidget()),
                  ),
                ],
              );
            },
          ),
        ),
        Builder(
          builder: (context) {
            double icSize = 0.15.sw.clamp(50, 75);
            return FlutterFloaty(
              borderRadius: 1.sw / 2,
              initialWidth: icSize,
              initialHeight: icSize,
              initialX: 1.sw - icSize - 0.025.sw,
              initialY: 0.65.sh,
              onTap: () {
                NavigatorRouter.pushNamed(
                  context,
                  TransactionsRoutes.createNewTransactionName,
                );
              },
              backgroundColor: ColorConstant.primary,
              builder: (context) {
                return const Icon(Icons.add, color: Colors.white);
              },
            );
          },
        ),
      ],
    );
  }
}
