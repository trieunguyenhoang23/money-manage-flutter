import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../export/core_external.dart';
import '../../export/ui_external.dart';
import '../../features/main_features/profile/data/datasource/local/user_local_datasource.dart';
import '../../infrastructure/network/network_info.dart';
import '../constant/string_constant.dart';

@lazySingleton
class OnlineActionGuard {
  final NetworkInfo _networkInfo;
  final UserLocalDatasource _userLocalDatasource;
  final FlutterSecureStorage _secureStorage;

  OnlineActionGuard(
    this._networkInfo,
    this._userLocalDatasource,
    this._secureStorage,
  );

  Future<void> run(
    Future<void> Function(String userId, bool isOnline) action,
  ) async {
    try {
      final bool isConnected = await _networkInfo.isConnected;
      if (!isConnected) return;

      final String? token = await _secureStorage.read(key: tokenKey);
      if (token == null) return;

      final user = await _userLocalDatasource.getCurrentUser();
      final String? userId = user?.idServer;

      if (userId != null) {
        await action(userId, isConnected);
      } else {
        debugPrint("OnlineActionGuard: Action skipped - User ID is null");
      }
    } catch (e, stackTrace) {
      debugPrint("OnlineActionGuard Error: $e");
      debugPrintStack(stackTrace: stackTrace);
    }
  }
}
