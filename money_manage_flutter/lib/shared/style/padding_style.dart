import 'package:money_manage_flutter/export/ui_external.dart';

class PaddingStyle extends StatelessWidget {
  final Widget child;
  final bool isPadding;
  final bool isVerticalPadding;

  const PaddingStyle({
    super.key,
    required this.child,
    this.isPadding = true,
    this.isVerticalPadding = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isPadding ? 0.05.sw : 0,
        vertical: isVerticalPadding ? 0.025.sh : 0,
      ),
      child: child,
    );
  }
}
