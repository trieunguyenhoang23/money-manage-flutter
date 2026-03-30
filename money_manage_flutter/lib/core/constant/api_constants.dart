class APIConstants {
  static const String bareUrl = 'http://192.168.1.8:2305';
}

class UserAuthAPI {
  /// POST
  static String get post_verify_auth =>
      '${APIConstants.bareUrl}/post/user-auth/verify_authenticate';

  static String get post_refresh_token =>
      '${APIConstants.bareUrl}/post/user-auth/refresh_token';
}

class UserBaseAPI {
  /// PATCH
  static String get patch_user => '${APIConstants.bareUrl}/patch/users';
}

class SyncAPI {
  /// POST
  static String get post_sync_batch_category =>
      '${APIConstants.bareUrl}/post/sync/batch-category';

  static String get post_sync_batch_transaction =>
      '${APIConstants.bareUrl}/post/sync/batch-transaction';
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

class TransactionAPI {
  /// GET
  static String get get_load_by_page =>
      '${APIConstants.bareUrl}/get/transactions/load_by_page';

  /// POST
  static String get post_transactions =>
      '${APIConstants.bareUrl}/post/transactions';

  /// PATCH
  static String get patch_transactions =>
      '${APIConstants.bareUrl}/patch/transactions';

  /// DELETE
  static String get delete_transactions =>
      '${APIConstants.bareUrl}/delete/transactions';
}
