class UserRemoteModel {
  final String id;
  final String primaryEmail;
  final String displayName;
  final String avatarUrl;
  final DateTime createdAt;

  const UserRemoteModel({
    required this.id,
    required this.primaryEmail,
    required this.displayName,
    required this.avatarUrl,
    required this.createdAt,
  });

  factory UserRemoteModel.fromJson(Map<String, dynamic> json) {
    return UserRemoteModel(
      id: json['id'],
      primaryEmail: json['primary_email'],
      displayName: json['display_name'],
      avatarUrl: json['avatar_url'],
      createdAt: json['created_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'primary_email': primaryEmail,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
