import 'tasks/i_background_task.dart';
import 'tasks/sync_category_task.dart';
import 'tasks/sync_transaction_task.dart';

class TaskRegistry {
  static final Map<String, BackgroundTask> _tasks = {
    SyncCategoryTask.identifier: SyncCategoryTask(),
    SyncTransactionTask.identifier: SyncTransactionTask(),
  };

  static Future<bool> handle(
    String taskName,
    Map<String, dynamic>? inputData,
  ) async {
    final task = _tasks[taskName];
    if (task != null) {
      return await task.run(inputData);
    }
    return false;
  }
}
