import 'package:money_manage_flutter/core/di/injection.config.dart';
import 'package:money_manage_flutter/export/core_external.dart';

final getIt = GetIt.instance;
@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async => getIt.init();