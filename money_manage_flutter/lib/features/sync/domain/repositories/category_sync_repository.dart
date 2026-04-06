import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../data/model/sync_delta_model.dart';

abstract class CategorySyncRepository {
  Future<Either<Failure, SyncDeltaModel>> loadCateDelta({
    String? lastTimeSync,
    int page = 0,
  });

  Future<({int total, int notSynced})> getCategorySyncStatus();

  Future<Either<Failure, int>> syncCategory(int limitCount);
}
