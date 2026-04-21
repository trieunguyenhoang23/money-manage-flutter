import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import 'package:money_manage_flutter/features/main_features/transactions/data/model/local/transaction_local_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../core/constant/string_constant.dart';
import '../../model/local/user_local_model.dart';

@LazySingleton()
class UserLocalDatasource {
  final Isar _isar;
  final SharedPreferences _preferences;
  final FlutterSecureStorage _secureStorage;

  UserLocalDatasource(this._isar, this._secureStorage, this._preferences);

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _secureStorage.write(key: tokenKey, value: accessToken);
    await _secureStorage.write(key: refreshTokenKey, value: refreshToken);
  }

  Future<void> saveUser(UserLocalModel user) async {
    await _isar.writeTxn(() async {
      await _isar.userLocalModels.put(user);
    });
  }

  Future<void> updateCurrency(String newCurrency) async {
    final user = await _isar.userLocalModels.where().findFirst();
    if (user != null) {
      user.currency = newCurrency;
      await _isar.writeTxn(() async {
        await _isar.userLocalModels.put(user);
      });

      return;
    }

    /// If user hasn't login in yet
    _preferences.setString(currencyKey, newCurrency);
  }

  Future<UserLocalModel?> getCurrentUser() async {
    return await _isar.userLocalModels.where().findFirst();
  }

  Future<String> getCurrentCurrency() async {
    final user = await _isar.userLocalModels.where().findFirst();

    if (user != null) {
      return user.currency ?? 'VND';
    }

    /// If user hasn't login in yet
    return _preferences.getString(currencyKey) ?? 'VND';
  }

  /// Clean up during Logout
  Future<void> clearSession() async {
    await _secureStorage.deleteAll();
    await _isar.writeTxn(() async {
      await _isar.userLocalModels.clear();
      await _isar.transactionLocalModels.clear();
    });
  }
}
