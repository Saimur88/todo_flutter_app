import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class FirebaseNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    await _messaging.requestPermission();

    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@ipmap/ic_launcher');

    const InitializationSettings initializationSettings =
    InitializationSettings(android: initializationSettingsAndroid);

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

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
}