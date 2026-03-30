import 'package:money_manage_flutter/export/core_external.dart';
import '../../data/model/sync_batch_progress.dart';
import '../repositories/sync_repository.dart';

@LazySingleton()
class SyncTransactionUseCase {
  final SyncRepository _syncRepository;

  SyncTransactionUseCase(this._syncRepository);

  static const limitCount = 20;

  Stream<SyncBatchProgress> execute() async* {
    // Get the total of unsync item
    final currentStatus = await _syncRepository.getTransactionSyncStatus();
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
      final result = await _syncRepository.syncTransaction(limitCount);

      if (result.isLeft()) {
        final error = result.fold((l) => l, (r) => null);
        throw error!;
      }

      final newStatus = await _syncRepository.getTransactionSyncStatus();
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

// Future<void> seed50TransactionsWithRealBytes() async {
//   final categories = await getIt<CategoryLocalDatasource>().loadByPage(
//     0,
//     100,
//   );
//   if (categories.isEmpty) {
//     print("Chưa có Category nào, hãy seed Category trước!");
//     return;
//   }
//
//   final Uint8List realBytes = base64Decode(
//     "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==",
//   );
//
//   final List<TransactionLocalModel> testTransactions = List.generate(50, (
//       index,
//       ) {
//     final category = categories[index % categories.length];
//
//     final bool hasImage = index % 3 == 0;
//
//     final double randomAmount = (index + 1) * 20000.0;
//
//     final transaction = TransactionLocalModel(
//       idServer: const Uuid().v4(),
//       type: category.type ?? TransactionType.EXPENSE,
//       amount: randomAmount,
//       note:
//       "Giao dịch test #${index + 1} (${hasImage ? 'Có ảnh' : 'Không ảnh'})",
//       categoryId: category.idServer ?? '',
//       transactionAt: DateTime.now().subtract(Duration(hours: index)),
//       createdAt: DateTime.now(),
//       updatedAt: DateTime.now(),
//       imageBytes: hasImage ? realBytes : null,
//       isSynced: false,
//     );
//
//     // Link Isar Category
//     transaction.category.value = category;
//
//     return transaction;
//   });
//
//   await getIt<TransactionsLocalDatasource>().saveAll(testTransactions);
//
//   print("✅ Đã seed 50 Transactions thành công!");
//   print(
//     "📸 Số lượng có ảnh: ${testTransactions.where((t) => t.imageBytes != null).length}",
//   );
// }
