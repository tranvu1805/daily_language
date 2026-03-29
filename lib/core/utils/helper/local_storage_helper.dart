import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageHelper {
  final SharedPreferences _prefs;

  LocalStorageHelper(this._prefs);

  static const String _notificationsKey = 'notifications_enabled';

  bool get areNotificationsEnabled => _prefs.getBool(_notificationsKey) ?? true;

  Future<void> setNotificationsEnabled(bool value) async {
    await _prefs.setBool(_notificationsKey, value);
  }
}
