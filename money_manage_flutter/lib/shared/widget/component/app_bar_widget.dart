import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/features/sync/presentation/widget/sync_indicator_widget.dart';
import '../../../export/ui_external.dart';

class AppBarWidget extends StatelessWidget implements PreferredSize {
  final String title;
  final List<Widget>? actionBtn;
  final bool isLeading;
  final bool isSetting;
  final Function()? onTapLeading;
  final bool isShowThemeBtn;
  final bool isCentralTitle;
  final bool isShowSubscription;

  const AppBarWidget({
    super.key,
    required this.title,
    this.actionBtn,
    this.isLeading = true,
    this.onTapLeading,
    this.isSetting = false,
    this.isShowThemeBtn = true,
    this.isCentralTitle = false,
    this.isShowSubscription = false,
  });

  @override
  Widget build(BuildContext context) {
    double icSize = (20 / 812).sh.clamp(20, 50);
    double horizontalPadding = 0.04.sw;

    return AppBar(
      // Avoid changing color when scrolling
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      centerTitle: isCentralTitle,
      titleSpacing: horizontalPadding,
      leadingWidth: icSize + horizontalPadding,
      leading: Padding(
        padding: EdgeInsets.only(left: horizontalPadding),
        child: isSetting
            ? BtnAppbarWidget(
                icPath: IcPathConstant.icMenu,
                onTap: () => Scaffold.of(context).openDrawer(),
              )
            : isLeading
            ? BtnAppbarWidget(
                icPath: IcPathConstant.icLeading,
                onTap: () {
                  if (onTapLeading != null) {
                    onTapLeading!();
                  } else {
                    Navigator.pop(context);
                  }
                },
              )
            : const SizedBox(),
      ),
      title: TextGGStyle(
        title,
        0.05.sw.clamp(15, 30),
        fontWeight: FontWeight.w900,
        color: ColorConstant.primary,
      ),
      actions: [
        const SyncIndicatorWidget(),
        if (actionBtn != null) ...[
          ...actionBtn!,
          SizedBox(width: horizontalPadding),
        ] else ...[
          SizedBox(width: horizontalPadding),
        ],
      ],
    );
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(0.075.sh);
}
