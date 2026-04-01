import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';

class ProfileThemeWidget extends ConsumerWidget {
  const ProfileThemeWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);
    final themeNotifier = ref.read(themeProvider.notifier);

    bool isLightMode = themeState.brightness == Brightness.light;

    return LayoutBuilder(
      builder: (context, cc) {
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: context.colorScheme.onSurface,
                width: 0.5,
              ),
            ),
          ),
          child: Row(
            children: [
              Icon(
                isLightMode ? Icons.light_mode : Icons.dark_mode,
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
                    value: isLightMode,
                    onChanged: (value) async {
                      await themeNotifier.switchTheme();
                      ss(() {
                        isLightMode = value;
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
