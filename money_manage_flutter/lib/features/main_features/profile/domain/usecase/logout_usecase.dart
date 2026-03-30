import 'package:injectable/injectable.dart';
import '../../../../../core/data/datasource/sync_lazy_loading.dart';
import '../../../../category/domain/repositories/category_repository.dart';
import '../../../transactions/domain/repositories/transaction_repository.dart';
import '../repositories/user_repository.dart';

@LazySingleton()
class LogoutUseCase {
  final UserRepository _userRepository;
  final CategoryRepository _categoryRepository;
  final TransactionRepository _transactionRepository;
  final SyncLazyLoading _SyncLazyLoading;

  LogoutUseCase(
    this._userRepository,
    this._categoryRepository,
    this._transactionRepository,
    this._SyncLazyLoading,
  );

  Future<void> execute() async {
    await _transactionRepository.clearAllData();
    await _categoryRepository.clearAllData();
    await _userRepository.clearSession();

    /// Reset loading data state
    await _SyncLazyLoading.resetSync(SyncSchema.reminder);
    await _SyncLazyLoading.resetSync(SyncSchema.category);
    await _SyncLazyLoading.resetSync(SyncSchema.transaction);
  }
}
