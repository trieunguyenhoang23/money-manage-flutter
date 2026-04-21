import 'package:money_manage_flutter/export/infrastructure.dart';
import '../../../../../../core/enum/auth_enum.dart';

class AuthProvider {
  final String? id;
  final String providerUserId;
  final String providerEmail;
  final ProviderAccountType providerType;
  final DateTime? createdAt;
  final String? userId;

  const AuthProvider({
    this.id,
    required this.providerUserId,
    required this.providerEmail,
    required this.providerType,
    this.createdAt,
    this.userId,
  });

  factory AuthProvider.fromJson(Map<String, dynamic> json) {
    return AuthProvider(
      id: json['id'] ?? '',
      providerUserId: json['provider_user_id'] ?? '',
      providerEmail: json['provider_email'] ?? '',
      providerType: ProviderAccountType.values.byName(
        json['provider_type'] ?? '',
      ),
      createdAt: DateTime.parse(json['created_at'] ?? ''),
      userId: json['user_id'] ?? '',
    );
  }

  factory AuthProvider.fromSocialAuth(SocialUser socialUser) {
    return AuthProvider(
      providerUserId: socialUser.id,
      providerEmail: socialUser.email,
      providerType: socialUser.type,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'provider_user_id': providerUserId,
      'provider_email': providerEmail,
      'provider_type': providerType.name,
    };
  }
}

