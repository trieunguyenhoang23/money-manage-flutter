import 'package:dartz/dartz.dart';
import '../../../../core/error/failure.dart';

abstract class SyncRepository {
  /// Category
  Future<Either<Failure, int>> syncCategory(int limitCount);

  Future<({int total, int notSynced})> getCategorySyncStatus();

  /// Transaction
  Future<Either<Failure, int>> syncTransaction(int limitCount);

  Future<({int total, int notSynced})> getTransactionSyncStatus();
}
