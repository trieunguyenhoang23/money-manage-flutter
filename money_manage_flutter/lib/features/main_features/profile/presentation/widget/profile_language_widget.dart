import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/router.dart';
import 'package:money_manage_flutter/export/shared.dart';
import 'package:money_manage_flutter/export/ui_external.dart';

class ProfileLanguageWidget extends ConsumerWidget {
  const ProfileLanguageWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, cc) {
        return InkWell(
          onTap: () {
            NavigatorRouter.pushNamed(context, ProfileRoutes.languageName);
          },
          child: Container(
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
                const Icon(Icons.translate, color: ColorConstant.warning700),
                SizedBox(width: 0.05 * cc.maxWidth),
                TextGGStyle(context.lang.language, 0.3 * cc.maxHeight),
                Expanded(
                  child: Container(
                    alignment: Alignment.centerRight,
                    child: TextGGStyle(
                      L10n.getLanguageName(ref.read(langProvider)),
                      0.3 * cc.maxHeight,
                      maxLines: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
