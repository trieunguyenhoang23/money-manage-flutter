import '../../export/core_external.dart';
import 'social_auth_service.dart';

@LazySingleton()
class AppleAuthService implements SocialAuthService {
  @override
  Future<SocialUser?> signIn() {
    // TODO: implement signIn
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }
}
