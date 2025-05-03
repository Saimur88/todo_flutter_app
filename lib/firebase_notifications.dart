import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class FirebaseNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _messaging.requestPermission();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('app_icon');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    tz.initializeTimeZones();

    String? token = await _messaging.getToken();
    print("🔑 FCM Token: $token");


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint("🔔 Notification clicked");
    });
  }

  void showLocalNotification(RemoteMessage message) {
    const AndroidNotificationDetails androidPlatformChanelSpecifics =
     AndroidNotificationDetails(
        'default_channel',
        'Default',
      importance: Importance.max,
      priority: Priority.high,
      showWhen: false,
     );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChanelSpecifics);

    _flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title ?? 'No Title',
        message.notification?.body ?? 'No Body',
        platformChannelSpecifics,
    );
  }

  Future<void> scheduleTaskNotification({
  required int id,
  required String title,
  required String body,
  required DateTime scheduledTime,
}) async {
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id, title, body,
        tz.TZDateTime.from(scheduledTime, tz.local),
        const NotificationDetails(
          android: AndroidNotificationDetails(
              'task_channel',
              'Task Notifications',
          importance: Importance.high,
          priority: Priority.high,),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelTaskNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

}