import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FcmService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
  FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. Request permission
    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    // 2. Setup local notifications (for foreground messages)
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    await _localNotifications.initialize(
      const InitializationSettings(android: androidSettings),
    );

    // 3. Create notification channel
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'fitmind_channel',
      'FitMind Notifications',
      description: 'Meal, workout and water reminders',
      importance: Importance.high,
    );

    final plugin = _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await plugin?.createNotificationChannel(channel);

    // 4. Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
  }

  // Call this after login
  Future<String?> getToken() async {
    return await _messaging.getToken();
  }

  // Call this to listen for token refresh
  void listenToTokenRefresh(Function(String token) onRefresh) {
    _messaging.onTokenRefresh.listen(onRefresh);
  }

  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'fitmind_channel',
          'FitMind Notifications',
          importance: Importance.high,
          priority: Priority.high,
        ),
      ),
    );
  }
}