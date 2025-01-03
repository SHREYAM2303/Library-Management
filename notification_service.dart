import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // Initialize notifications
  Future<void> initializeNotifications() async {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: IOSInitializationSettings(),
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // Show notification
  Future<void> showNotification(String title, String body) async {
    final NotificationDetails notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'default_channel',
        'Default Channel',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }
}
