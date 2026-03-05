import 'package:auto_size_text_plus/auto_size_text_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_manage_flutter/export/ui_external.dart';

class TextGGStyle extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color? color;
  final int maxLines;
  final double textHeight;
  final TextAlign textAlign;
  final bool isAutoSizeTet;
  final bool isUnderLine;
  final bool isShadow;
  final FontWeight? fontWeight;
  final TextStyle? style;

  const TextGGStyle(
    this.text,
    this.fontSize, {
    this.color,
    this.maxLines = 3,
    this.textHeight = 1.25,
    this.isAutoSizeTet = true,
    this.textAlign = TextAlign.left,
    this.isUnderLine = false,
    this.isShadow = false,
    this.fontWeight,
    this.style,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final finalStyle = styleCommon(
      fontSize: fontSize,
      color: color,
      textHeight: textHeight,
      isUnderLine: isUnderLine,
      isShadow: isShadow,
      fontWeight: fontWeight,
      customStyle: style,
    );

    return isAutoSizeTet
        ? AutoSizeText(
            text,
            minFontSize: 1,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
            textAlign: textAlign,
            style: finalStyle,
          )
        : Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: maxLines,
            textAlign: textAlign,
            style: finalStyle,
          );
  }
}

TextStyle styleCommon({
  required double fontSize,
  Color? color,
  required double textHeight,
  required bool isUnderLine,
  required bool isShadow,
  FontWeight? fontWeight,
  TextStyle? customStyle,
}) {
  final base = customStyle ?? GoogleFonts.montserrat();

  return base.copyWith(
    color: color ?? base.color,
    fontWeight: fontWeight ?? base.fontWeight,
    fontSize: fontSize,
    height: textHeight,
    decoration: isUnderLine ? TextDecoration.underline : TextDecoration.none,
    shadows: isShadow
        ? [
            Shadow(
              offset: const Offset(0, 2),
              blurRadius: 4,
              color: Colors.black.withValues(alpha: 0.25),
            ),
          ]
        : null,
  );
}
