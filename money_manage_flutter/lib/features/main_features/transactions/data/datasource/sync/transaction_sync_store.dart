import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../core/enum/transaction_type.dart';
import 'transaction_sync_key.dart';
import 'transaction_sync_progress.dart';

@LazySingleton()
class TransactionSyncStore {
  final SharedPreferences _prefs;

  TransactionSyncStore(this._prefs);

  static const String _prefix = 'sync_trans';

  String _buildKey(TransactionSyncKey key, String subType) {
    return key.toKey('${_prefix}_$subType');
  }

  // --- READ ---
  TransactionSyncProgress getProgress(TransactionSyncKey key) {
    final lastPage = _prefs.getInt(key.toKey(_buildKey(key, 'page'))) ?? 0;

    final hasReachedEnd =
        _prefs.getBool(key.toKey(_buildKey(key, 'end'))) ?? false;

    return TransactionSyncProgress(
      lastPage: lastPage,
      hasReachedEnd: hasReachedEnd,
    );
  }

  // --- WRITE ---
  Future<void> savePage(TransactionSyncKey key, int page) async {
    await _prefs.setInt(_buildKey(key, 'page'), page);
  }

  Future<void> markReachedEnd(TransactionSyncKey key) async {
    // Marked itself
    await _prefs.setBool(key.toKey(_buildKey(key, 'end')), true);

    // Transitive logic
    if (key.type == null) {
      // Nếu ALL is exhausted -> Mark both sub-branches
      await _markEndByType(key.year, key.month, TransactionType.INCOME);
      await _markEndByType(key.year, key.month, TransactionType.EXPENSE);
    } else {
      // If the sub-branch is exhausted -> Check if the remaining sub-branch is also exhausted
      final otherType = key.type == TransactionType.INCOME
          ? TransactionType.EXPENSE
          : TransactionType.INCOME;
      final otherKey = TransactionSyncKey(
        year: key.year,
        month: key.month,
        type: otherType,
      );

      final otherEnded =
          _prefs.getBool(otherKey.toKey(_buildKey(otherKey, 'end'))) ?? false;

      if (otherEnded) {
        // Both are exhausted -> Mark all
        final allKey = TransactionSyncKey(
          year: key.year,
          month: key.month,
          type: null,
        );
        await _prefs.setBool(allKey.toKey(_buildKey(allKey, 'end')), true);
      }
    }
  }

  Future<void> _markEndByType(int year, int month, TransactionType type) async {
    final key = TransactionSyncKey(year: year, month: month, type: type);
    await _prefs.setBool(_buildKey(key, 'end'), true);
  }

  // --- RESET ---
  Future<void> reset(TransactionSyncKey key) async {
    // Remove the "end" flag so that isFullyReachedEnd return false;
    final endKey = _buildKey(key, 'end');
    await _prefs.remove(endKey);

    // Set default page = 0
    final pageKey = _buildKey(key, 'page');
    await _prefs.remove(pageKey);

    // Reset key type (INCOME / EXPENSE)
    if (key.type == null) {
      await _resetByType(key.year, key.month, TransactionType.INCOME);
      await _resetByType(key.year, key.month, TransactionType.EXPENSE);
    }
  }

  Future<void> _resetByType(int year, int month, TransactionType type) async {
    final key = TransactionSyncKey(year: year, month: month, type: type);
    await _prefs.remove(_buildKey(key, 'end'));
    await _prefs.remove(_buildKey(key, 'page'));
  }

  bool isFullyReachedEnd(TransactionSyncKey key) {
    // Check itself
    if (getProgress(key).hasReachedEnd) return true;

    // Checking Transitive logic
    if (key.type == null) {
      final incomeKey = TransactionSyncKey(
        year: key.year,
        month: key.month,
        type: TransactionType.INCOME,
      );
      final expenseKey = TransactionSyncKey(
        year: key.year,
        month: key.month,
        type: TransactionType.EXPENSE,
      );

      if (getProgress(incomeKey).hasReachedEnd &&
          getProgress(expenseKey).hasReachedEnd) {
        return true;
      }
    }

    // Checking the bridging logic applies to the "Income/Expense" cases
    if (key.type != null) {
      final allKey = TransactionSyncKey(
        year: key.year,
        month: key.month,
        type: null,
      );
      if (getProgress(allKey).hasReachedEnd) return true;
    }

    return false;
  }

  Future<void> clearAllSyncProgress() async {
    final allKeys = _prefs.getKeys();
    final syncKeys = allKeys.where((key) => key.startsWith(_prefix)).toList();

    for (final key in syncKeys) {
      await _prefs.remove(key);
    }
  }
}
