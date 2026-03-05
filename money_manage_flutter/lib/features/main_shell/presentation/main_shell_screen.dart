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
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: widget.navigationShell,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: [
              shadowStyle(ColorConstant.neutral300, const Offset(0, 5), 10),
            ],
            color: ColorConstant.neutral200,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: List.generate(bottomTabBars.length, (index) {
                  final tab = bottomTabBars[index];
                  final isSelected =
                      widget.navigationShell.currentIndex == index;
                  return InkWell(
                    onTap: () {
                      NavigationShellHolder.shell?.goBranch(
                        index,
                        initialLocation: true,
                      );
                    },
                    child: SizedBox(
                      height: 0.07.sh,
                      width: 1.sw / bottomTabBars.length,
                      child: BottomNavigationWidget(
                        tab: tab,
                        isSelected: isSelected,
                      ),
                    ),
                  );
                }),
              ),
              SizedBox(height: 0.015.sh),
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
