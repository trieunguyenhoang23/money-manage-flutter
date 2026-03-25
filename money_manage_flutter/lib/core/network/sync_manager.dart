import '../../export/core_external.dart';
import '../../export/ui_external.dart';
import '../../features/main_features/profile/domain/repositories/user_repository.dart';
import '../../infrastructure/network/network_info.dart';

@lazySingleton
class SyncManager {
  final NetworkInfo _networkInfo;
  final UserRepository _userRepository;

  SyncManager(this._networkInfo, this._userRepository);

  Future<void> runIfMeetStandard(
    Future<void> Function(String currentActiveUserId, bool networkStatus)
    action,
  ) async {
    final bool isLogin = await _userRepository.checkIsLogin();
    final bool isConnected = await _networkInfo.isConnected;

    if (isLogin && isConnected) {
      try {
        String currentActiveUserId = await _userRepository.getCurrentUserId();

        await action(currentActiveUserId, isConnected);
      } catch (e) {
        debugPrint("SyncManager Error: $e");
      }
    }
  }
}
