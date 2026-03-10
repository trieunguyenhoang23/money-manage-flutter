import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/shared.dart';
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
    return AppBar(
      //Tránh đổi màu khi scroll
      surfaceTintColor: Colors.transparent,
      automaticallyImplyLeading: false,
      backgroundColor: Colors.transparent,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (isSetting)
            BtnAppbarWidget(
              icPath: IcPathConstant.icMenu,
              onTap: () => Scaffold.of(context).openDrawer(),
            )
          else
            BtnAppbarWidget(
              icPath: IcPathConstant.icLeading,
              onTap: () {
                if (onTapLeading != null) {
                  onTapLeading!();
                } else {
                  Navigator.pop(context);
                }
              },
            ),
          if (!isCentralTitle) SizedBox(width: 0.025.sw),
          Expanded(
            child: Container(
              alignment: isCentralTitle
                  ? Alignment.center
                  : Alignment.centerLeft,
              child: TextGGStyle(
                title,
                0.05.sw.clamp(7, 20),
                fontWeight: FontWeight.w900,
                color: ColorConstant.primary,
              ),
            ),
          ),

          if (actionBtn != null) ...actionBtn! else SizedBox(width: 0.0175.sw),
        ],
      ),
    );
  }

  @override
  // TODO: implement child
  Widget get child => throw UnimplementedError();

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(0.075.sh);
}
