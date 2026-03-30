import 'package:money_manage_flutter/export/ui_external.dart';
import 'package:money_manage_flutter/export/core.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: ColorConstant.neutral50,
    colorScheme: const ColorScheme.light(
      primary: ColorConstant.primary,
      onPrimary: Colors.black,
      secondary: ColorConstant.primary900,
      onSecondary: ColorConstant.neutral900,
      // Support a third color for both primary and secondary elements
      tertiary: ColorConstant.primary300,
      onTertiary: Colors.black,

      /// Background
      background: ColorConstant.neutral50,
      onBackground: ColorConstant.neutral900,

      ///Bg form, input, Bg Bottom bar
      surface: ColorConstant.neutral100,

      ///Icon Bottom bar
      onSurface: ColorConstant.neutral600,

      error: ColorConstant.error500,
      onError: Colors.white,
    ),
  );

  static final darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: ColorConstant.neutral900,

    colorScheme: const ColorScheme.dark(
      primary: ColorConstant.primary,
      onPrimary: Colors.white,
      secondary: ColorConstant.primary700,
      onSecondary: Colors.black,
      // Support a third color for both primary and secondary elements
      tertiary: ColorConstant.primary300,
      onTertiary: ColorConstant.primary300,
      background: ColorConstant.neutral800,
      onBackground: ColorConstant.neutral50,

      ///Bg form, input, Bg Bottom bar
      surface: ColorConstant.neutral700,

      ///Icon Bottom bar
      onSurface: ColorConstant.neutral300,
      error: ColorConstant.error400,
      onError: Colors.black,
    ),
  );
}
