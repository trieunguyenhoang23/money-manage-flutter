import 'main_tab.dart';
import 'widget/bottom_navigation_widget.dart';
import 'package:money_manage_flutter/export/router.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/ui_external.dart';

class MainShellScreen extends StatefulWidget {
  final StatefulNavigationShell navigationShell;

  const MainShellScreen({super.key, required this.navigationShell});

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  @override
  void initState() {
    super.initState();
    NavigationShellHolder.shell = widget.navigationShell;
  }

  @override
  Widget build(BuildContext context) {
    double wBottomBar = 1.sw;
    double hBottomBar = (wBottomBar * 80 / 375).clamp(70, 90);
    Radius bottomBarRadius = const Radius.circular(20);

    return PopScope(
      canPop: false,
      child: Scaffold(
        appBar: AppBarWidget(
          title: 'Money Manage',
          isSetting: true,
          isCentralTitle: true,
          actionBtn: [
            BtnAppbarWidget(
              widget: const Icon(
                Icons.category_outlined,
                color: ColorConstant.primary,
              ),
              onTap: () {
                NavigatorRouter.pushNamed(
                  context,
                  CategoryRoutes.categoryName,
                  pathParameters: {},
                );
              },
            ),
          ],
        ),
        body: widget.navigationShell,
        bottomNavigationBar: Container(
          width: wBottomBar,
          height: hBottomBar,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: bottomBarRadius,
              topRight: bottomBarRadius,
            ),
            boxShadow: [
              shadowStyle(ColorConstant.neutral300, const Offset(0, 5), 10),
            ],
            color: Colors.white,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ///Bottom Bar Item
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(bottomTabBars.length, (index) {
                  final tab = bottomTabBars[index];
                  final isSelected =
                      widget.navigationShell.currentIndex == index;

                  double wItem = (1.sw / bottomTabBars.length).clamp(55, 65);
                  double hItem = ((41 / 80) * hBottomBar).clamp(50, 60);

                  return InkWell(
                    onTap: () {
                      NavigationShellHolder.shell?.goBranch(
                        index,
                        initialLocation: true,
                      );
                    },
                    child: SizedBox(
                      width: wItem,
                      height: hItem,
                      child: BottomNavigationWidget(
                        tab: tab,
                        isSelected: isSelected,
                      ),
                    ),
                  );
                }),
              ),
              Container(
                color: Colors.white,
                height:
                    MediaQuery.paddingOf(context).bottom /
                    MediaQuery.devicePixelRatioOf(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
