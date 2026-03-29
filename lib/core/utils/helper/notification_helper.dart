import 'package:daily_language/core/di/service_locator.dart';
import 'package:daily_language/core/utils/helper/local_storage_helper.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationHelper {
  final FlutterLocalNotificationsPlugin _notificationsPlugin;

  NotificationHelper(this._notificationsPlugin);

  Future<void> init() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _notificationsPlugin.initialize(settings: initializationSettings);
  }

  Future<void> requestPermission() async {
    final androidImplementation = _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidImplementation != null) {
      await androidImplementation.requestNotificationsPermission();
    }
  }

  Future<void> scheduleDailyReminder({bool forceTomorrow = false}) async {
    final isEnabled = sl<LocalStorageHelper>().areNotificationsEnabled;
    if (!isEnabled) return;

    // Cancel existing one first
    await _notificationsPlugin.cancel(id: 0);

    // Schedule for custom time from LocalStorage
    final localStorage = sl<LocalStorageHelper>();
    final now = tz.TZDateTime.now(tz.local);
    var scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      localStorage.reminderHour,
      localStorage.reminderMinute,
    );

    if (forceTomorrow || scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    await _notificationsPlugin.zonedSchedule(
      id: 0,
      title: 'Nhắc nhở học tập',
      body:
          'Đã đến lúc học tiếng Anh rồi! Đừng quên duy trì streak của bạn nhé.',
      scheduledDate: scheduledDate,
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder',
          'Daily Reminder',
          channelDescription: 'Remind user to learn daily',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
  }) async {
    const androidNotificationDetails = AndroidNotificationDetails(
      'immediate_notification',
      'Immediate Notification',
      importance: Importance.max,
      priority: Priority.high,
    );
    const notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _notificationsPlugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: notificationDetails,
    );
  }

  Future<void> cancelAll() async {
    await _notificationsPlugin.cancelAll();
  }
}
