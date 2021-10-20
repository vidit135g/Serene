import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationProvider {
  //
  Future selectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
    }
  }

  showNotificiation({String title, String body, String payload}) async {
    var flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin.initialize(
      InitializationSettings(
        android: AndroidInitializationSettings('ic_stat_name'),
      ),
      onSelectNotification: selectNotification,
    );
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'clean-habits-reminders',
      'Reminders',
      'Clean Habits Reminders',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'reminders',
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }
}
