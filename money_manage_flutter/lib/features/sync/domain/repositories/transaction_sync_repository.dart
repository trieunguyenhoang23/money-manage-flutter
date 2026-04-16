import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../data/model/sync_delta_model.dart';

abstract class TransactionSyncRepository {
  Future<Either<Failure, SyncDeltaModel>> pullTransactionDelta({
    String? lastTimeSync,
    required int page,
    required int limitCount,
  });

  Future<Either<Failure, int>> pushTransactionDelta(int limitCount);

  Future<({int notSynced, int total})> getTransactionSyncStatus();
}
