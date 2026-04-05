import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@LazySingleton()
class CategorySyncStore {
  final SharedPreferences _prefs;

  CategorySyncStore(this._prefs);

  static const String _keyLastPage = 'category_sync_last_page_';
  static const String _keyHasReachedEnd = 'category_sync_has_reached_end_';

  // --- Page Management ---
  int getLastPage() {
    return _prefs.getInt(_keyLastPage) ?? 1;
  }

  Future<void> setLastPage(int page) async {
    await _prefs.setInt(_keyLastPage, page);
  }

  // --- Boundary Management  ---
  bool hasReachedEnd() {
    return _prefs.getBool(_keyHasReachedEnd) ?? false;
  }

  Future<void> setReachedEnd(bool value) async {
    await _prefs.setBool(_keyHasReachedEnd, value);
  }

  // --- Reset ---
  Future<void> resetSync() async {
    await _prefs.remove(_keyLastPage);
    await _prefs.remove(_keyHasReachedEnd);
  }
}
