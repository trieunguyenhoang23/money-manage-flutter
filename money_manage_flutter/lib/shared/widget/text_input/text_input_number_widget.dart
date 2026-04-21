import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:money_manage_flutter/core/constant/color_constant.dart';
import 'package:money_manage_flutter/core/utils/currency_formatter_utils.dart';
import 'package:money_manage_flutter/export/ui_external.dart';

class TextInputNumberWidget extends StatelessWidget {
  final String? title;
  final String hintText;
  final TextEditingController textController;
  final Function(String) onChange;
  final Function(String) onSubmit;
  final Function() onClearText;
  final String? Function(String?)? validator;

  const TextInputNumberWidget({
    super.key,
    this.title,
    this.validator,
    required this.hintText,
    required this.textController,
    required this.onChange,
    required this.onSubmit,
    required this.onClearText,
  });

  @override
  Widget build(BuildContext context) {
    final border = const UnderlineInputBorder(
      borderSide: BorderSide(color: ColorConstant.primary),
    );
    return TextFormField(
      controller: textController,
      onChanged: (value) {
        onChange.call(value);
      },
      onFieldSubmitted: (value) {
        onSubmit.call(value);
        FocusManager.instance.primaryFocus?.unfocus();
      },
      validator: validator,
      textAlign: TextAlign.center,
      textAlignVertical: TextAlignVertical.center,
      minLines: 1,
      cursorColor: ColorConstant.primary,
      keyboardType: TextInputType.number,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        CurrencyInputFormatter(maxLength: 13),
      ],
      decoration: InputDecoration(
        errorMaxLines: 2,
        hintText: hintText,
        hintStyle: GoogleFonts.urbanist(color: ColorConstant.neutral300),
        isDense: true,
        enabledBorder: border,
        focusedBorder: border,
        border: border,
      ),
    );
  }
}
