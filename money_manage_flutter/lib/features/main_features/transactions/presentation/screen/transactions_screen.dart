import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:money_manage_flutter/core/constant/color_constant.dart';
import 'package:money_manage_flutter/export/router.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../../../../core/router/navigator_router.dart';
import '../../../../../shared/widget/btn/btn_floating_widget.dart';
import '../widget/month_select_widget.dart';
import '../widget/transaction_grid_view_widget.dart';
import '../widget/year_select_widget.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ExtendedNestedScrollView(
          onlyOneScrollInBody: true,
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle: ExtendedNestedScrollView.sliverOverlapAbsorberHandleFor(
                  context,
                ),
                sliver: SliverAppBar(
                  pinned: true,
                  floating: false,
                  titleSpacing: 0,
                  title: const YearSelectWidget(),
                  bottom: const MonthSelectWidget(),
                  centerTitle: true,
                  toolbarHeight: (158 / 375).sw.clamp(0, 207) * 35 / 158 + 10,
                  automaticallyImplyLeading: false,
                ),
              ),
            ];
          },
          body: const TransactionGridViewWidget(),
        ),
        FlutterFloaty(
          key: UniqueKey(),
          borderRadius: 1.sw / 2,
          initialWidth: 0.15.sw,
          initialHeight: 0.15.sw,
          initialX: 1.sw - 0.15.sw - 0.025.sw,
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
        ),
      ],
    );
  }
}
