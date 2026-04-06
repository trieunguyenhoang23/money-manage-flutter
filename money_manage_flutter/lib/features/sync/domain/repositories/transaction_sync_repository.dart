import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../data/model/sync_delta_model.dart';

abstract class TransactionSyncRepository {
  Future<Either<Failure, SyncDeltaModel>> loadTransactionDelta({
    String? lastTimeSync,
    required int page,
  });

  Future<({int notSynced, int total})> getTransactionSyncStatus();

  Future<Either<Failure, int>> syncTransaction(int limitCount);
}
