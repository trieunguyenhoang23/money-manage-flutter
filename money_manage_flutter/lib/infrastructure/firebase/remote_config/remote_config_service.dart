import 'package:flutter/material.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

class RemoteConfigService {
  static final FirebaseRemoteConfig _remoteConfig =
      FirebaseRemoteConfig.instance;

  static Future initFirebaseRemoteConfig() async {
    await _setConfigurationFirebase();

    try {
      await _remoteConfig.fetchAndActivate();
      _remoteConfig.fetch();
    } catch (e) {
      debugPrint('Error initFirebaseRemoteConfig $e');
    }

    await _getDefaultValues();
  }

  static Future<void> _getDefaultValues() async {}

  static Future<void> _setConfigurationFirebase() async {
    await _remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 10),
        minimumFetchInterval: const Duration(seconds: 1),
      ),
    );
  }

  static T getRemoteConfigValue<T>({
    required String key,
    required T defaultValue,
  }) {
    _remoteConfig.setDefaults({key: defaultValue});

    if (T == bool) {
      return _remoteConfig.getBool(key) as T;
    } else if (T == int) {
      return _remoteConfig.getInt(key) as T;
    } else if (T == double) {
      return _remoteConfig.getDouble(key) as T;
    } else if (T == String) {
      return _remoteConfig.getString(key) as T;
    }

    throw UnsupportedError("Type $T is not supported");
  }
}
