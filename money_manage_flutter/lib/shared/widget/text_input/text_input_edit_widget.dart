import 'package:google_fonts/google_fonts.dart';
import 'package:money_manage_flutter/core/constant/color_constant.dart';
import 'package:money_manage_flutter/export/ui_external.dart';

class TextInputEditWidget extends StatelessWidget {
  final String? title;
  final String hintText;
  final TextEditingController textController;
  final Function(String) onChange;
  final Function(String) onSubmit;
  final Function() onClearText;
  final int maxLines;
  final int maxLength;

  final bool showCounter;

  const TextInputEditWidget({
    super.key,
    this.title,
    required this.hintText,
    required this.textController,
    required this.onChange,
    required this.onSubmit,
    required this.onClearText,
    this.maxLines = 1,
    this.maxLength = 200,

    this.showCounter = true,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, cc) {
        double w = cc.maxWidth;
        double h = cc.maxHeight;

        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(h * 0.1)),
          child: Container(
            color: ColorConstant.neutral200,
            height: h,
            child: Center(
              child: TextFormField(
                controller: textController,
                onChanged: (value) {
                  onChange.call(value);
                },
                onFieldSubmitted: (value) {
                  onSubmit.call(value);
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                maxLength: maxLength,
                textAlign: TextAlign.left,
                textAlignVertical: TextAlignVertical.center,
                maxLines: maxLines,
                minLines: 1,
                cursorColor: ColorConstant.primary,
                decoration: InputDecoration(
                  hintText: hintText,
                  counterText: showCounter ? null : '',
                  hintStyle: GoogleFonts.urbanist(
                    color: ColorConstant.neutral300,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                  prefixIconConstraints: BoxConstraints(
                    minWidth: w * 0.025,
                    minHeight: w * 0.025,
                  ),
                  prefixIcon: Padding(
                    padding: EdgeInsets.only(left: cc.maxWidth * 0.025),
                    child: const SizedBox(),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      onClearText.call();
                      textController.text = '';
                      FocusManager.instance.primaryFocus?.unfocus();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: ColorConstant.neutral400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
