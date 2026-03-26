import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import '../../../../../shared/style/text_gg_style.dart';

class ProfileThemeWidget extends ConsumerWidget {
  const ProfileThemeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    bool switchValue = true;

    return LayoutBuilder(
      builder: (context, cc) {
        return Container(
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.black12, width: 0.5),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                // theme.brightness == Brightness.light
                //     ? Icons.dark_mode
                //     : Icons.light_mode,
                Icons.light_mode,
                color: ColorConstant.warning700,
              ),
              SizedBox(width: 0.05 * cc.maxWidth),
              TextGGStyle(context.lang.profile_theme, 0.3 * cc.maxHeight),
              const Spacer(),
              StatefulBuilder(
                builder: (context, ss) {
                  return Switch(
                    activeThumbColor: Colors.white,
                    activeTrackColor: ColorConstant.primary,
                    value: switchValue,
                    onChanged: (value) {
                      ss(() {
                        switchValue = value;
                      });
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
