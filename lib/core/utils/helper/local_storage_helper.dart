import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageHelper {
  final SharedPreferences _prefs;

  LocalStorageHelper(this._prefs);

  static const String _notificationsKey = 'notifications_enabled';
  static const String _localeKey = 'app_locale';

  bool get areNotificationsEnabled => _prefs.getBool(_notificationsKey) ?? true;
  String get appLocale => _prefs.getString(_localeKey) ?? 'en';

  Future<void> setNotificationsEnabled(bool value) async {
    await _prefs.setBool(_notificationsKey, value);
  }

  Future<void> setAppLocale(String localeCode) async {
    await _prefs.setString(_localeKey, localeCode);
  }
}
