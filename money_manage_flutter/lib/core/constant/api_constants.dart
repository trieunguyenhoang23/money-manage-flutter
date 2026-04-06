class APIConstants {
  static const String bareUrl = 'http://192.168.1.9:2305';
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
  /// GET
  static String get get_transaction_sync_delta =>
      '${APIConstants.bareUrl}/get/transactions/sync_delta';

  static String get get_category_sync_delta =>
      '${APIConstants.bareUrl}/get/categories/sync_delta';

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
  static String get get_load_by_month =>
      '${APIConstants.bareUrl}/get/transactions/load_by_month';

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

class AnalyticsAPI {
  /// GET
  static String get get_financial_data =>
      '${APIConstants.bareUrl}/get/analytics/financial-data';

  static String get get_spending_categories =>
      '${APIConstants.bareUrl}/get/analytics/spending-categories';

  static String get get_overview =>
      '${APIConstants.bareUrl}/get/analytics/overview';
}
