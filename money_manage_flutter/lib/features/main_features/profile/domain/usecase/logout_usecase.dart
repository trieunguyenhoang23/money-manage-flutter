import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:money_manage_flutter/core/constant/string_constant.dart';
import 'package:money_manage_flutter/features/main_features/transactions/data/datasource/sync/transaction_sync_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../category/data/datasource/sync/category_sync_store.dart';
import '../../../../category/domain/repositories/category_repository.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../repositories/user_repository.dart';

@LazySingleton()
class LogoutUseCase {
  final UserRepository _userRepository;
  final CategoryRepository _categoryRepository;
  final TransactionRepository _transactionRepository;
  final CategorySyncStore _categorySyncStore;
  final FlutterSecureStorage _secureStorage;
  final TransactionSyncStore _transactionSyncStore;

  LogoutUseCase(
    this._userRepository,
    this._categoryRepository,
    this._transactionRepository,
    this._categorySyncStore,
    this._secureStorage,
    this._transactionSyncStore,
  );

  Future<void> execute() async {
    await _transactionRepository.clearAllData();
    await _categoryRepository.clearAllData();
    await _userRepository.clearSession();

    /// Reset loading data store
    await _categorySyncStore.resetSync();
    await _transactionSyncStore.clearAllSyncProgress();

    await _secureStorage.deleteAll();
  }
}
