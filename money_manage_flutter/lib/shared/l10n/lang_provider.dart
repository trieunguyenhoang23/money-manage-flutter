import 'dart:ui';
import 'package:hooks_riverpod/legacy.dart';
import 'package:money_manage_flutter/export/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LangProvider extends StateNotifier<Locale> {
  static const _localeKey = 'app_local';
  static const _defaultLocale = Locale('en');

  LangProvider() : super(_defaultLocale) {
    _loadLocale();
  }

  final prefs = getIt<SharedPreferences>();

  Future<void> _loadLocale() async {
    final code = prefs.getString(_localeKey);
    if (code != null) {
      state = Locale(code);
    }
  }

  Future<void> switchLang(Locale locale) async {
    await prefs.setString(_localeKey, locale.languageCode);
    state = locale;
  }
}

final langProvider = StateNotifierProvider<LangProvider, Locale>(
  (ref) => LangProvider(),
);
