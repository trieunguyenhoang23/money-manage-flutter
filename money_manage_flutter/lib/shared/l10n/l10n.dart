import 'dart:ui';

class L10n {
  static final List<Locale> all = [
    const Locale('en'),        // English
    const Locale('vi'),        // Vietnamese
  ];

  static String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'vi':
        return '🇻🇳 Tiếng Việt - Vietnamese';
      case 'en':
      default:
        return '🇬🇧 English - English';
    }
  }
}
