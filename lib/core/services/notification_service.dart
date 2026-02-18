// Notification service using flutter_local_notifications
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../utils/constants.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  /// Initialize the notification plugin.
  static Future<void> init() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(initSettings);
    _initialized = true;
  }

  /// Show notification when silent mode activates.
  static Future<void> showSilentStartNotification(String profileName) async {
    const androidDetails = AndroidNotificationDetails(
      AppConstants.notifChannelId,
      AppConstants.notifChannelName,
      channelDescription: 'SilentGuard schedule alerts',
      importance: Importance.low,
      priority: Priority.low,
      icon: '@mipmap/ic_launcher',
      ongoing: false,
      autoCancel: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      AppConstants.notifIdSilentStart,
      '🔇 Silent Mode Active',
      'Profile "$profileName" is now active',
      details,
    );
  }

  /// Show notification when silent mode ends.
  static Future<void> showSilentEndNotification(String profileName) async {
    const androidDetails = AndroidNotificationDetails(
      AppConstants.notifChannelId,
      AppConstants.notifChannelName,
      channelDescription: 'SilentGuard schedule alerts',
      importance: Importance.low,
      priority: Priority.low,
      icon: '@mipmap/ic_launcher',
      autoCancel: true,
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      AppConstants.notifIdSilentEnd,
      '🔔 Sound Restored',
      'Profile "$profileName" ended – sound restored',
      details,
    );
  }

  /// Cancel all notifications.
  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  /// Cancel a specific notification.
  static Future<void> cancel(int id) async {
    await _plugin.cancel(id);
  }
}
