import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {

  static final FlutterLocalNotificationsPlugin notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // INITIALIZE NOTIFICATIONS
  static Future init() async {

    // Initialize timezone
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings settings =
        InitializationSettings(android: androidSettings);

    await notificationsPlugin.initialize(settings);
  }

  // INSTANT NOTIFICATION
  static Future showNotification(String title, String body) async {

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      "disease_channel",
      "Disease Alerts",
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await notificationsPlugin.show(
      0,
      title,
      body,
      details,
    );
  }

  // SCHEDULED REMINDER
  static Future scheduleReminder(
      String title,
      String body,
      int seconds) async {

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      "reminder_channel",
      "Treatment Reminder",
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details =
        NotificationDetails(android: androidDetails);

    await notificationsPlugin.zonedSchedule(
      1,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
      details,

      // IMPORTANT FOR ANDROID
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}