import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import '../../../../category/domain/repositories/category_repository.dart';
import '../../../../sync/data/datasource/local/sync_local_storage.dart';
import '../../../transactions/data/datasource/sync/transaction_sync_store.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../repositories/user_repository.dart';

@LazySingleton()
class LogoutUseCase {
  final UserRepository _userRepository;
  final CategoryRepository _categoryRepository;
  final TransactionRepository _transactionRepository;
  final SyncLocalStorage _syncLocalStorage;
  final FlutterSecureStorage _secureStorage;
  final TransactionSyncStore _transactionSyncStore;

  LogoutUseCase(
    this._userRepository,
    this._categoryRepository,
    this._transactionRepository,
    this._syncLocalStorage,
    this._secureStorage,
    this._transactionSyncStore,
  );

  Future<void> execute() async {
    await _userRepository.logOut();

    await _transactionRepository.clearAllData();
    await _categoryRepository.clearAllData();
    await _userRepository.clearSession();

    await _syncLocalStorage.resetSync(SyncSchema.category);
    await _syncLocalStorage.resetSync(SyncSchema.transaction);
    await _syncLocalStorage.resetSync(SyncSchema.reminder);
    await _transactionSyncStore.clearAllSyncProgress();
    await _secureStorage.deleteAll();
  }
}
