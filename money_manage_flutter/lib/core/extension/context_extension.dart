import 'package:money_manage_flutter/export/ui_external.dart';
import '../../generated/l10n.dart';

extension ContextExtension on BuildContext {
  ///Lang
  S get lang => S.of(this);

  //ColorScheme
  ThemeData get theme => Theme.of(this);

  ColorScheme get colorScheme => theme.colorScheme;
}
