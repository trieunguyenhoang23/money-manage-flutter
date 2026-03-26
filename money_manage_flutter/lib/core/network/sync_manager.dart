import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../export/core_external.dart';
import '../../export/ui_external.dart';
import '../../features/main_features/profile/data/datasource/local/user_local_datasource.dart';
import '../../infrastructure/network/network_info.dart';
import '../constant/string_constant.dart';

@lazySingleton
class SyncManager {
  final NetworkInfo _networkInfo;
  final UserLocalDatasource _userLocalDatasource;
  final FlutterSecureStorage _secureStorage;

  SyncManager(
    this._networkInfo,
    this._userLocalDatasource,
    this._secureStorage,
  );

  Future<void> runIfMeetStandard(
    Future<void> Function(String currentActiveUserId, bool networkStatus)
    action,
  ) async {
    final bool isLogin = (await _secureStorage.read(key: tokenKey)) != null;
    final bool isConnected = await _networkInfo.isConnected;

    if (isLogin && isConnected) {
      try {
        String currentActiveUserId =
            (await _userLocalDatasource.getCurrentUser())!.idServer!;

        await action(currentActiveUserId, isConnected);
      } catch (e) {
        debugPrint("SyncManager Error: $e");
      }
    }
  }
}
