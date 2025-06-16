import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:food_app/model/AppNotification.dart';

List<AppNotification> notifications = [];

// Background message handler
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("📩 Background message received: ${message.notification?.title}");

  final newNotif = AppNotification(
    title: message.notification?.title ?? 'No Title',
    body: message.notification?.body ?? 'No Body',
    time: DateTime.now(),
  );

  notifications.add(newNotif);
}

class NotificationServices {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initFCM() async {
    await _firebaseMessaging.requestPermission();

    final fcmToken = await _firebaseMessaging.getToken();
    print('🎯 FCM Token: $fcmToken');

    // Foreground notification listener
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📥 Foreground message: ${message.notification?.title}');
      final newNotif = AppNotification(
        title: message.notification?.title ?? 'No Title',
        body: message.notification?.body ?? 'No Body',
        time: DateTime.now(),
      );
      notifications.add(newNotif);
    });


    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('🟢 Notification opened: ${message.notification?.title}');
      final newNotif = AppNotification(
        title: message.notification?.title ?? 'No Title',
        body: message.notification?.body ?? 'No Body',
        time: DateTime.now(),
      );
      notifications.add(newNotif);
    });

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}