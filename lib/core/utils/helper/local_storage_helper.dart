import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageHelper {
  final SharedPreferences _prefs;

  LocalStorageHelper(this._prefs);

  static const String _notificationsKey = 'notifications_enabled';
  static const String _localeKey = 'app_locale';
  static const String _reminderHourKey = 'reminder_hour';
  static const String _reminderMinuteKey = 'reminder_minute';

  bool get areNotificationsEnabled => _prefs.getBool(_notificationsKey) ?? true;
  String get appLocale => _prefs.getString(_localeKey) ?? 'en';
  int get reminderHour => _prefs.getInt(_reminderHourKey) ?? 21;
  int get reminderMinute => _prefs.getInt(_reminderMinuteKey) ?? 30;

  Future<void> setNotificationsEnabled(bool value) async {
    await _prefs.setBool(_notificationsKey, value);
  }

  Future<void> setAppLocale(String localeCode) async {
    await _prefs.setString(_localeKey, localeCode);
  }

  Future<void> setReminderTime(int hour, int minute) async {
    await _prefs.setInt(_reminderHourKey, hour);
    await _prefs.setInt(_reminderMinuteKey, minute);
  }
}
