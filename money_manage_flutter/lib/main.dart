import 'export/shared.dart';
import 'export/core.dart';
import 'export/ui_external.dart';
import 'generated/l10n.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();
  await initializeDateFormatting();

  // await Workmanager().initialize(callbackDispatcher, isInDebugMode: kDebugMode);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lang = ref.watch(langProvider);
    final theme = ref.watch(themeProvider);

    return ScreenUtilInit(
      designSize: const Size(375, 812),

      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerConfig: AppRouter.router,
        locale: lang,
        theme: theme,
        builder: (context, child) {
          SizeAppUtils().getSizeApp(context);
          return child ?? Container();
        },
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}
