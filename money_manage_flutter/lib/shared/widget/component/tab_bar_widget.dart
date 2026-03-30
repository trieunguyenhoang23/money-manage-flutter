import 'package:google_fonts/google_fonts.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../style/text_gg_style.dart';
import 'btn_main_widget.dart';

class TabBarWidget extends StatefulWidget {
  final TabController tabController;
  final List<String> listType;

  const TabBarWidget({
    super.key,
    required this.tabController,
    required this.listType,
  });

  @override
  State<TabBarWidget> createState() => _TabBarWidgetState();
}

class _TabBarWidgetState extends State<TabBarWidget>
    with TickerProviderStateMixin {
  List<String> get listType => widget.listType;

  TabController get tabController => widget.tabController;
  late ValueNotifier<int> onPageChangeNotifier;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onPageChangeNotifier = ValueNotifier(tabController.index);

    tabController.animation?.addListener(() {
      final value = tabController.animation!.value.round();
      onPageChangeNotifier.value = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthBtn = (158 / 375).sw.clamp(0, 207);
    double heightBtn = (widthBtn * 35 / 158).clamp(0, 42);

    return ValueListenableBuilder(
      valueListenable: onPageChangeNotifier,
      builder: (context, value, _) {
        return SizedBox(
          width: widthBtn * 2 + 0.025.sw,

          height: heightBtn,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(listType.length, (index) {
              bool isSelected = value == index;

              return BtnMainWidget(
                w: widthBtn,
                h: heightBtn,
                radius: widthBtn / 2,
                color: isSelected
                    ? ColorConstant.primary
                    : context.colorScheme.onSurface,
                child: TextGGStyle(
                  listType[index],
                  widthBtn.clamp(10, 15),
                  color: isSelected ? Colors.white : ColorConstant.neutral200,
                  style: GoogleFonts.urbanist(),
                  fontWeight: FontWeight.w600,
                ),
                onTap: () {
                  tabController.animateTo(index);
                },
              );
            }),
          ),
        );
      },
    );
  }
}
