import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(macOS: darwinSettings);

    await _plugin.initialize(settings: settings);
  }

  static Future<void> showTestNotification() async {
    const details = NotificationDetails(macOS: DarwinNotificationDetails());

    await _plugin.show(
      id: 0,
      title: 'Smart Health',
      body: 'Your test notification is working!',
      notificationDetails: details,
    );
  }
}
