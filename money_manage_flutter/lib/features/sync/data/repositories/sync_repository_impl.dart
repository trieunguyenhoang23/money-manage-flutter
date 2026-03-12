import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failure.dart';
import '../../../category/data/datasource/local/category_local_datasource.dart';
import '../../domain/repositories/sync_repository.dart';
import '../datasource/remote/sync_remote_datasource.dart';

@LazySingleton(as: SyncRepository)
class SyncRepositoryImpl implements SyncRepository {
  final CategoryLocalDatasource _categoryLocalDatasource;
  final SyncRemoteDatasource _remoteSyncDatasource;

  SyncRepositoryImpl(this._categoryLocalDatasource, this._remoteSyncDatasource);

  @override
  Future<Either<Failure, Unit>> syncAll() async {
    try {
      //  Collect all local data
      final categories = await _categoryLocalDatasource.getAll();
      // final transactions = await _transactionLocal.getAll();
      // final reminders = await _reminderLocal.getAll();

      // Body json request
      final manifest = {
        'categories': categories.map((e) => e.toJson()).toList(),
        'transactions': [],
        //transactions.map((e) => e.toRemoteJson()).toList(),
        'reminders': [],
        //reminders.map((e) => e.toRemoteJson()).toList(),
      };

      if (kDebugMode) {
        print('manifest $manifest');
      }

      // Send to Server
      final response = await _remoteSyncDatasource.syncUserData(manifest);
      if (response.isFailure) {
        return Left(
          ServerFailure("Server rejected sync: ${response.error?.message}"),
        );
      }

      // Mark local as synced
      await _categoryLocalDatasource.markAllAsSynced(categories);

      return const Right(unit);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
