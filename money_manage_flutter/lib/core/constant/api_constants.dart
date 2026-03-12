class APIConstants {
  static const String bareUrl = 'http://192.168.1.6:2305';
}

class UserAuthAPI {
  static String get post_verify_auth =>
      '${APIConstants.bareUrl}/post/user-auth/verify_authenticate';

  static String get post_refresh_token =>
      '${APIConstants.bareUrl}/post/user-auth/refresh_token';
}

class SyncAPI {
  static String get post_sync_user_data =>
      '${APIConstants.bareUrl}/post/sync/user-data';
}

class CategoryAPI {
  static String get get_load_by_page =>
      '${APIConstants.bareUrl}/get/categories/load_by_page';
}
