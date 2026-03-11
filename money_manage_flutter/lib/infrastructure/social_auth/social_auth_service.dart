import 'package:money_manage_flutter/core/enum/auth_enum.dart';

abstract class SocialAuthService {
  Future<SocialUser?> signIn();

  Future<void> signOut();
}

class SocialUser {
  final String id;
  final String email;
  final String name;
  final String avatarUrl;
  final ProviderAccountType type;

  SocialUser({
    required this.id,
    required this.email,
    required this.name,
    required this.avatarUrl,
    required this.type,
  });

  Map<String, dynamic> toJson() {
    return {
      'provider_user_id': id,
      'provider_email': email,
      'provider_type': type.name,
      'display_name': name,
      'avatar_url': avatarUrl,
    };
  }
}
