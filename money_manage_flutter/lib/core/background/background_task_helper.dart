import 'package:workmanager/workmanager.dart';
import 'tasks/sync_category_task.dart';
import 'tasks/sync_transaction_task.dart';

class BackgroundTaskHelper {
  static void scheduleSync() {
    Workmanager().registerPeriodicTask(
      SyncCategoryTask.identifier,
      SyncCategoryTask.identifier,
      frequency: const Duration(minutes: 15),
      initialDelay: const Duration(minutes: 5),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
    );

    Workmanager().registerPeriodicTask(
      SyncTransactionTask.identifier,
      SyncTransactionTask.identifier,
      frequency: const Duration(minutes: 15),
      initialDelay: const Duration(minutes: 5),
      constraints: Constraints(
        networkType: NetworkType.connected,
        requiresBatteryNotLow: true,
      ),
      existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
    );
  }
}
