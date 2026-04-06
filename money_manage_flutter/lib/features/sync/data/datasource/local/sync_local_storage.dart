import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SyncSchema { category, transaction, reminder }

@LazySingleton()
class SyncLocalStorage {
  final SharedPreferences _prefs;

  SyncLocalStorage(this._prefs);

  static const String _keyLastSyncTime = 'sync_last_time_';

  static const String _keyIsFirstSyncCompleted = 'is_first_sync_completed_';

  bool isFirstSyncCompleted(SyncSchema schema) {
    return _prefs.getBool('$_keyIsFirstSyncCompleted${schema.name}') ?? false;
  }

  Future<void> setFirstSyncCompleted(SyncSchema schema, bool value) async {
    await _prefs.setBool('$_keyIsFirstSyncCompleted${schema.name}', value);
  }

  // --- Timestamp Management ---
  String? getLastSyncTime(SyncSchema schema) {
    return _prefs.getString('$_keyLastSyncTime${schema.name}');
  }

  Future<void> setLastSyncTime(SyncSchema schema, String isoTimestamp) async {
    await _prefs.setString('$_keyLastSyncTime${schema.name}', isoTimestamp);
  }

  // --- Reset  ---
  Future<void> resetSync(SyncSchema schema) async {
    await _prefs.remove('$_keyLastSyncTime${schema.name}');
    await _prefs.remove('$_keyIsFirstSyncCompleted${schema.name}');
  }
}
