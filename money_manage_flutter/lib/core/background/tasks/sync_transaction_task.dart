import '../../../export/ui_external.dart';
import '../../../features/sync/domain/usecase/sync_transaction/sync_transaction_usecase.dart';
import '../../di/injection.dart';
import 'i_background_task.dart';

class SyncTransactionTask implements BackgroundTask {
  static const String identifier = 'com.money_manage.sync_transaction_task';

  @override
  String get taskName => identifier;

  @override
  Future<bool> run(Map<String, dynamic>? inputData) async {
    final syncTransactionUseCase = getIt<SyncTransactionUseCase>();

    await for (final progress in syncTransactionUseCase.execute()) {
      debugPrint("Syncing Transaction: ${progress.current}");
    }
    return true;
  }
}
