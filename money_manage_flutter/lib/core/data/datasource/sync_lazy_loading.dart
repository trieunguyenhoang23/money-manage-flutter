import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SyncSchema { category, transaction, reminder }

@LazySingleton()
class SyncLazyLoading {
  final SharedPreferences _prefs;

  SyncLazyLoading(this._prefs);

  static const String _keyLastPage = 'sync_last_page_';
  static const String _keyHasReachedEnd = 'sync_has_reached_end_';

  // --- Page Management ---
  int getLastPage(SyncSchema schema) {
    return _prefs.getInt('$_keyLastPage${schema.name}') ?? 1;
  }

  Future<void> setLastPage(SyncSchema schema, int page) async {
    await _prefs.setInt('$_keyLastPage${schema.name}', page);
  }

  // --- Boundary Management  ---
  bool hasReachedEnd(SyncSchema schema) {
    return _prefs.getBool('$_keyHasReachedEnd${schema.name}') ?? false;
  }

  Future<void> setReachedEnd(SyncSchema schema, bool value) async {
    await _prefs.setBool('$_keyHasReachedEnd${schema.name}', value);
  }

  // --- Reset ---
  Future<void> resetSync(SyncSchema schema) async {
    await _prefs.remove('$_keyLastPage${schema.name}');
    await _prefs.remove('$_keyHasReachedEnd${schema.name}');
  }
}