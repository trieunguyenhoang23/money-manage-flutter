import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../widget/month_select_widget.dart';
import '../widget/year_select_widget.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen>
    with TickerProviderStateMixin {
  late TabController tabBarController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabBarController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    tabBarController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ExtendedNestedScrollView(
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
      body: TabBarView(
        controller: tabBarController,
        children: [Container(), Container()],
      ),
    );
  }
}
