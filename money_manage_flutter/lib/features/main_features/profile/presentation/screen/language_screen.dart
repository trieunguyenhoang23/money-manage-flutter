import 'package:go_router/go_router.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/shared.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {
  late Locale currentLocale;

  @override
  Widget build(BuildContext context) {
    double wBtn = 1.sw - 0.05.sw * 2;
    double hBtn = wBtn * 43 / 319;

    return Scaffold(
      backgroundColor: context.colorScheme.background,
      appBar: AppBarWidget(title: context.lang.language, isCentralTitle: true),
      body: PaddingStyle(
        child: Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(langProvider);
            currentLocale = state;

            return StatefulBuilder(
              builder: (context, ss) {
                return ListView.builder(
                  itemCount: L10n.all.length,
                  itemBuilder: (context, index) {
                    final locale = L10n.all[index];

                    final isSelected =
                        locale.languageCode == currentLocale.languageCode;

                    return GestureDetector(
                      onTap: () {
                        ss(() {
                          currentLocale = locale;
                        });
                      },
                      child: Container(
                        height: (0.75.sh - 0.05.sw * 2) / 11,
                        margin: EdgeInsets.only(bottom: 0.025.sh),
                        padding: EdgeInsets.symmetric(horizontal: 0.035.sw),
                        decoration: BoxDecoration(
                          color: context.colorScheme.surface,
                          border: isSelected
                              ? Border.all(
                                  color: ColorConstant.primary,
                                  width: 2,
                                )
                              : null,
                          borderRadius: BorderRadius.all(
                            Radius.circular(0.03.sw),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextGGStyle(
                              L10n.getLanguageName(locale),
                              0.04.sw,
                              color: context.colorScheme.onSurface,
                              fontWeight: FontWeight.bold,
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check,
                                color: ColorConstant.primary,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
      bottomNavigationBar: PaddingStyle(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Consumer(
              builder: (context, ref, _) {
                final notifier = ref.read(langProvider.notifier);

                return BtnMainWidget(
                  w: wBtn,
                  h: hBtn,
                  onTap: () {
                    notifier.switchLang(currentLocale);
                    context.pop();
                  },
                  color: ColorConstant.primary,
                  radius: wBtn * 0.025,
                  child: TextGGStyle(
                    context.lang.confirm,
                    wBtn * 0.05,
                    fontWeight: FontWeight.bold,
                    color: ColorConstant.neutral50,
                  ),
                );
              },
            ),
            const SpacingStyle(),
            Container(
              height:
                  MediaQuery.paddingOf(context).bottom /
                  MediaQuery.devicePixelRatioOf(context),
            ),
          ],
        ),
      ),
    );
  }
}
