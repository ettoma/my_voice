import 'package:audio_journal/screens/splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

  static const channelId = '123';

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // final AndroidInitializationSettings initializationSettingsAndroid =
    //     AndroidInitializationSettings('@mipmap/ic_launcher');

    const IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(
      // android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  final IOSNotificationDetails _iosNotificationDetails =
      const IOSNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    // subtitle: 'This is the notification',
  );

  // AndroidNotificationDetails _androidNotificationDetails =
  //     AndroidNotificationDetails(
  //   'channel ID',
  //   'channel name',
  //   playSound: true,
  //   priority: Priority.high,
  //   importance: Importance.high,
  // );

  // void requestIOSPermissions(
  //     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin) {
  //   flutterLocalNotificationsPlugin
  //       .resolvePlatformSpecificImplementation<
  //           IOSFlutterLocalNotificationsPlugin>()
  //       ?.requestPermissions(
  //         alert: true,
  //         badge: true,
  //         sound: true,
  //       );
  // }

  Future<void> showNotifications() async {
    await flutterLocalNotificationsPlugin.show(
      0,
      "Today's voice",
      "Have you already recorded your audio today?",
      NotificationDetails(
          // android: _androidNotificationDetails,
          iOS: _iosNotificationDetails),
    );
  }

  Future<void> scheduleDailyNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        "My voice",
        "Have you already recorded your audio today?",
        _nextInstanceOfSevenPM(),
        NotificationDetails(
          // android: AndroidNotificationDetails('daily notification channel id',
          //     'daily notification channel name',
          //     channelDescription: 'daily notification description'),
          iOS: _iosNotificationDetails,
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  tz.TZDateTime _nextInstanceOfSevenPM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 19);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  Future<void> cancelNotifications(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

Future selectNotification(context) async {
  await Navigator.push(
    context,
    MaterialPageRoute<void>(builder: (context) => const Splash()),
  );
}
