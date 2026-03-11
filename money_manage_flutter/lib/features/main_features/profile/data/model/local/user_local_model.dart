import 'package:isar_community/isar.dart';
import '../remote/user_remote_model.dart';

part 'user_local_model.g.dart';

@collection
class UserLocalModel {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  String? idServer;

  String? primaryEmail;
  String? displayName;
  String? avatarUrl;
  DateTime? createdAt;

  // Metadata for synchronization logic
  bool isSynced = false;

  UserLocalModel();

  // Mapping from Domain/Remote User to Local Isar Model
  factory UserLocalModel.fromDomain(Map<String, dynamic> userData) {
    return UserLocalModel()
      ..idServer = userData['id']
      ..primaryEmail = userData['primary_email']
      ..displayName = userData['display_name']
      ..avatarUrl = userData['avatar_url']
      ..createdAt = userData['created_at'] != null
          ? DateTime.parse(userData['created_at'] as String)
          : null
      ..isSynced = true;
  }

  // Use this when you need to send data back to your LoopBack API
  Map<String, dynamic> toJson() {
    return {
      'id': idServer,
      'primary_email': primaryEmail,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
