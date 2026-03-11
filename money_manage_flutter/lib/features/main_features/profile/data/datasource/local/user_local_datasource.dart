import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:isar_community/isar.dart';
import '../../../../../../core/constant/string_constant.dart';
import '../../model/local/user_local_model.dart';

@LazySingleton()
class UserLocalDatasource {
  Isar _isar;
  FlutterSecureStorage _secureStorage;

  UserLocalDatasource(this._isar, this._secureStorage);

  Future<void> saveTokens(String accessToken, String refreshToken) async {
    await _secureStorage.write(key: tokenKey, value: accessToken);
    await _secureStorage.write(key: refreshTokenKey, value: refreshToken);
  }

  Future<void> saveUser(UserLocalModel user) async {
    await _isar.writeTxn(() async {
      await _isar.userLocalModels.put(user);
    });
  }

  Future<UserLocalModel?> getCurrentUser() async {
    return await _isar.userLocalModels.where().findFirst();
  }

  /// Clean up during Logout
  Future<void> clearSession() async {
    await _secureStorage.deleteAll();
    await _isar.writeTxn(() async {
      await _isar.userLocalModels.clear();
    });
  }
}
