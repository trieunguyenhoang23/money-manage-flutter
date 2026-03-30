import '../../../../export/core_external.dart';
import '../../data/model/sync_batch_progress.dart';
import '../repositories/sync_repository.dart';

@injectable
class SyncCateUseCase {
  final SyncRepository _syncRepository;

  SyncCateUseCase(this._syncRepository);

  static const limitCount = 20;

  Stream<SyncBatchProgress> execute() async* {
    // Get the total of unsync item
    final currentStatus = await _syncRepository.getCategorySyncStatus();
    final total = currentStatus.total;
    int remaining = currentStatus.notSynced;

    if (remaining == 0) {
      yield SyncBatchProgress(
        type: SyncType.category,
        current: total,
        total: total,
        overallProgress: 1.0,
      );
      return;
    }

    while (remaining > 0) {
      final result = await _syncRepository.syncCategory(limitCount);

      if (result.isLeft()) {
        final error = result.fold((l) => l, (r) => null);
        throw error!;
      }

      final newStatus = await _syncRepository.getCategorySyncStatus();
      remaining = newStatus.notSynced;

      yield SyncBatchProgress(
        type: SyncType.category,
        current: total - remaining,
        total: total,
        overallProgress: (total - remaining) / total,
      );
    }
  }


}


// Future<void> seedTestData() async {
//   final List<CategoryLocalModel> testData = List.generate(100, (index) {
//     final isEven = index % 2 == 0;
//     return CategoryLocalModel.fromRemote({
//       "created_at": DateTime.now().toIso8601String(),
//       "description": "Mô tả test số $index",
//       "idServer": const Uuid().v4(),
//       "isSynced": false,
//       "name": isEven ? "Khoản thu $index" : "Khoản chi $index",
//       "type": isEven ? "INCOME" : "EXPENSE",
//       "updated_at": null,
//       "user_id": null,
//     });
//   });
//
//   await getIt<CategoryLocalDatasource>().saveAll(testData);
// }