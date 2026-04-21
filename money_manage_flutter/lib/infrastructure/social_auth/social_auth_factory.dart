import 'google_auth_service.dart';
import 'apple_auth_service.dart';
import 'social_auth_service.dart';
import 'package:money_manage_flutter/export/core_external.dart';

enum AuthMethod { google, apple }

@LazySingleton()
class SocialAuthFactory {
  final GoogleAuthService _googleAuth;
  final AppleAuthService _appleAuth;

  SocialAuthFactory(this._googleAuth, this._appleAuth);

  SocialAuthService getService(AuthMethod method) {
    switch (method) {
      case AuthMethod.google:
        return _googleAuth;
      case AuthMethod.apple:
        return _appleAuth;
    }
  }
}
