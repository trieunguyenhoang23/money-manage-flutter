import 'package:hooks_riverpod/legacy.dart';
import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/di/injection.dart';
import 'app_theme.dart';

class ThemeNotifier extends StateNotifier<ThemeData> {
  static const _themeKey = 'app_theme';

  ThemeNotifier() : super(AppTheme.lightTheme) {
    _loadTheme();
  }

  SharedPreferences preferences = getIt<SharedPreferences>();

  Future<void> _loadTheme() async {
    final theme = preferences.getString(_themeKey);

    if (theme == "dark") {
      state = AppTheme.darkTheme;
    } else {
      state = AppTheme.lightTheme;
    }
  }

  Future<void> switchTheme() async {
    state = (state.brightness == Brightness.light)
        ? AppTheme.darkTheme
        : AppTheme.lightTheme;

    if (state.brightness == Brightness.light) {
      await preferences.setString(_themeKey, 'light');
      return;
    }

    await preferences.setString(_themeKey, 'dark');
  }
}

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeData>(
  (ref) => ThemeNotifier(),
);
