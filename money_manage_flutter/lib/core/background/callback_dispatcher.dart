import 'package:workmanager/workmanager.dart';
import '../../export/ui_external.dart';
import '../di/injection.dart';
import 'task_registry.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    await configureDependencies();

    try {
      return await TaskRegistry.handle(taskName, inputData);
    } catch (e) {
      debugPrint("Background Task Error: $e");
      return false;
    }
  });
}
