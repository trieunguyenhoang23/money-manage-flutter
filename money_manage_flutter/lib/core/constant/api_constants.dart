class APIConstants {
  static const String bareUrl = 'http://192.168.1.6:2305';
}

class UserAuthAPI {
  /// POST
  static String get post_verify_auth =>
      '${APIConstants.bareUrl}/post/user-auth/verify_authenticate';

  static String get post_refresh_token =>
      '${APIConstants.bareUrl}/post/user-auth/refresh_token';
}

class SyncAPI {
  /// POST
  static String get post_sync_user_data =>
      '${APIConstants.bareUrl}/post/sync/user-data';
}

class CategoryAPI {
  /// GET
  static String get get_load_by_page =>
      '${APIConstants.bareUrl}/get/categories/load_by_page';

  /// POST
  static String get post_category => '${APIConstants.bareUrl}/post/categories';

  /// PATCH
  static String get patch_category_by_id =>
      '${APIConstants.bareUrl}/patch/categories';
}
