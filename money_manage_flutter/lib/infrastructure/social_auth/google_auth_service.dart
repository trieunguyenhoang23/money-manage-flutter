import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:money_manage_flutter/core/enum/auth_enum.dart';
import '../../export/core_external.dart';
import 'social_auth_service.dart';

@LazySingleton()
class GoogleAuthService implements SocialAuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _initialized = false;

  Future<void> _ensureInitialized() async {
    if (!_initialized) {
      await _googleSignIn.initialize(
        ///Thay client Id trong GoogleService-Info.plist
        clientId: Platform.isIOS ? 'YOUR_IOS_CLIENT_ID_IF_NEEDED' : null,
        serverClientId:
            '249271941631-uq021p3k62jla4ci5ujn9i6ophe178no.apps.googleusercontent.com',
      );
      _initialized = true;
    }
  }

  @override
  Future<SocialUser?> signIn() async {
    await _ensureInitialized();

    // Sử dụng authenticate thay vì signIn
    try {
      final account = await _googleSignIn.authenticate(scopeHint: ['email']);

      if (kDebugMode) {
        debugPrint('id ${account.id}');
        debugPrint('email ${account.email}');
        debugPrint('name ${account.displayName}');
        debugPrint('account.photoUrl ${account.photoUrl}');
      }

      return SocialUser(
        id: account.id,
        email: account.email,
        name: account.displayName ?? '',
        avatarUrl: account.photoUrl ?? '',
        type: ProviderAccountType.GOOGLE,
      );
    } catch (e) {
      debugPrint('Error signIn Social Auth $e');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }
}
