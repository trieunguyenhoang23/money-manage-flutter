import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/export/core.dart';
import '../../../main_features/transactions/data/datasource/local/transactions_local_datasource.dart';
import '../../domain/repositories/transaction_sync_repository.dart';
import '../../domain/service/transaction/transaction_pull_service.dart';
import '../../domain/service/transaction/transaction_push_service.dart';
import '../datasource/remote/sync_remote_datasource.dart';
import '../model/sync_delta_model.dart';

@LazySingleton(as: TransactionSyncRepository)
class TransactionSyncRepositoryImpl implements TransactionSyncRepository {
  final TransactionsLocalDatasource _transactionsLocalDatasource;
  final SyncRemoteDatasource _remoteSyncDatasource;
  final OnlineActionGuard _onlineActionGuard;
  final TransactionPullService _transactionPullService;
  final TransactionPushService _transactionPushService;

  TransactionSyncRepositoryImpl(
    this._transactionsLocalDatasource,
    this._remoteSyncDatasource,
    this._onlineActionGuard,
    this._transactionPullService,
    this._transactionPushService,
  );

  @override
  Future<Either<Failure, SyncDeltaModel>> pullTransactionDelta({
    String? lastTimeSync,
    required int page,
    required int limitCount,
  }) async {
    final result = await _remoteSyncDatasource.getTransactionSyncDelta(
      lastTimeSync: lastTimeSync,
      page: page,
      limit: limitCount,
    );

    if (result.isFailure) return Left(ServerFailure(result.error!.message!));
    final SyncDeltaModel syncDelta = SyncDeltaModel.fromJson(result.data);

    if (syncDelta.data.isEmpty) {
      return Right(syncDelta);
    }

    // Save category that transaction belong
    await _transactionPullService.saveCategoryIfNeeded(syncDelta.data);

    // Remove transaction
    await _transactionPullService.removeTransaction(syncDelta.data);

    // Update transaction
    await _transactionPullService.saveUpdatedTransaction(syncDelta.data);

    return Right(syncDelta);
  }

  @override
  Future<({int notSynced, int total})> getTransactionSyncStatus() async {
    final total = await _transactionsLocalDatasource.getLengthData();
    final notSynced = await _transactionsLocalDatasource
        .getLengthDataNotYetSync();
    return (total: total, notSynced: notSynced);
  }

  @override
  Future<Either<Failure, int>> pushTransactionDelta(int limitCount) async {
    Either<Failure, int> result = const Left(NetworkFailure("Not Internet"));

    await _onlineActionGuard.run((currentUserId, isConnected) async {
      try {
        // Get unsynced data
        final unsyncedTransactions = await _transactionsLocalDatasource
            .loadDataNotYetSync(limitCount);

        if (unsyncedTransactions.isEmpty) {
          result = const Right(0);
          return;
        }

        // Create payload Json
        final payloadJson = _transactionPushService.prepareSyncPayload(
          unsyncedTransactions,
          currentUserId,
        );

        final response = await _remoteSyncDatasource.syncTransaction(
          payloadJson.manifest,
          image_description_buffer_list: payloadJson.buffers,
          image_name_list: payloadJson.names,
        );

        if (response.isFailure) {
          result = Left(ServerFailure(response.error!.message ?? ''));
          return;
        }

        await _transactionsLocalDatasource.markAllAsSynced(
          unsyncedTransactions,
          currentUserId,
        );

        result = Right(unsyncedTransactions.length);
      } catch (e) {
        result = Left(ServerFailure(e.toString()));
      }
    });

    return result;
  }
}
