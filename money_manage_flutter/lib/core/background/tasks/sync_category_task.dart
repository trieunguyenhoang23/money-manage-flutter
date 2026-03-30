import 'package:flutter/cupertino.dart';
import '../../../features/sync/domain/usecase/sync_category_usecase.dart';
import '../../di/injection.dart';
import 'i_background_task.dart';

class SyncCategoryTask implements BackgroundTask {
  static const String identifier = "com.money_manage.sync_category_task";

  @override
  String get taskName => identifier;

  @override
  Future<bool> run(Map<String, dynamic>? inputData) async {
    final syncCateUseCase = getIt<SyncCateUseCase>();

    await for (final progress in syncCateUseCase.execute()) {
      debugPrint("Syncing category: ${progress.current}");
    }
    return true;
  }
}
