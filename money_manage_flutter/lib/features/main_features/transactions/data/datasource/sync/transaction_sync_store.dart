import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../core/enum/transaction_type.dart';
import 'transaction_sync_key.dart';
import 'transaction_sync_progress.dart';

@LazySingleton()
class TransactionSyncStore {
  final SharedPreferences _prefs;
  static const String _prefix = 'sync_trans';

  TransactionSyncStore(this._prefs);

  String _buildKey(TransactionSyncKey key, String suffix) =>
      key.toKey('${_prefix}_$suffix');

  TransactionSyncProgress getProgress(TransactionSyncKey key) {
    return TransactionSyncProgress(
      lastPage: _prefs.getInt(_buildKey(key, 'page')) ?? 0,
      hasReachedEnd: _prefs.getBool(_buildKey(key, 'end')) ?? false,
    );
  }

  Future<void> saveProgress(
    TransactionSyncKey key, {
    int? page,
    bool? end,
  }) async {
    if (page != null) await _prefs.setInt(_buildKey(key, 'page'), page);
    if (end != null) await _prefs.setBool(_buildKey(key, 'end'), end);
  }

  Future<void> reset(TransactionSyncKey key) async {
    await _prefs.remove(_buildKey(key, 'page'));
    await _prefs.remove(_buildKey(key, 'end'));

    // Reset relative branches if key is All
    if (key.type == null) {
      await reset(key.copyWith(type: TransactionType.INCOME));
      await reset(key.copyWith(type: TransactionType.EXPENSE));
    }
  }

  Future<void> clearAllSyncProgress() async {
    final allKeys = _prefs.getKeys();
    final syncKeys = allKeys.where((key) => key.startsWith(_prefix)).toList();

    for (final key in syncKeys) {
      await _prefs.remove(key);
    }
  }
}
