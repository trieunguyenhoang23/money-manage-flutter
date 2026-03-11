class APIConstants {
  static const String bareUrl = 'http://192.168.1.6:2305';
}

class UserAuth {
  static String get verifyAuth =>
      '${APIConstants.bareUrl}/post/user-auth/verify_authenticate';

  static String get refreshToken =>
      '${APIConstants.bareUrl}/post/user-auth/refresh_token';
}
