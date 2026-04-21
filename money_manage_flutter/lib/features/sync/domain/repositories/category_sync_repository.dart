import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';
import '../../data/model/sync_delta_model.dart';

abstract class CategorySyncRepository {
  Future<Either<Failure, SyncDeltaModel>> pullCategoryDelta({
    String? lastTimeSync,
    required int page,
    required int limitCount,
  });

  Future<({int total, int notSynced})> getCategorySyncStatus();

  Future<Either<Failure, int>> pushCategoryDelta(int limitCount);
}
