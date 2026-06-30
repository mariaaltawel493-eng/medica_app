import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FcmHelper {
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  /// تهيئة الإشعارات بالكامل وتفعيل المستمعات
  static Future<void> initFcm() async {
    // طلب صلاحيات الإشعارات من المستخدم
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('🔔 FCM: تمت الموافقة على صلاحيات الإشعارات بنجاح.');
    }

    // إعدادات الأندرويد الأساسية للأيقونة
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log('🔔 FCM: تم الضغط على الإشعار المحلي: ${response.payload}');
      },
    );

    // [المستمع الأول]: والتطبيق مفتوح (Foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log(
        '🔔 FCM: استقبلنا إشعاراً والتطبيق مفتوح: ${message.notification?.title}',
      );
      _showLocalNotification(message);
    });

    // [المستمع الثاني]: عند الضغط من الخلفية (Background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log('🔔 FCM: تم فتح التطبيق عبر الضغط على الإشعار من الخلفية!');
    });
  }

  /// جلب الـ FCM Token الخاص بالجهاز
  static Future<String?> getToken() async {
    try {
      String? token = await _firebaseMessaging.getToken();
      log('🔑 FCM Token: $token');
      return token;
    } catch (e) {
      log('❌ FCM: فشل جلب التوكن: $e');
      return null;
    }
  }

  /// عرض الإشعار المنبثق
  static void _showLocalNotification(RemoteMessage message) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'medica_notifications_channel',
          'Medica Notifications',
          channelDescription: 'هذه القناة مخصصة لإشعارات تطبيق Medica الطبي',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localNotificationsPlugin.show(
      id: message.hashCode,
      title: message.notification?.title,
      body: message.notification?.body,
      notificationDetails: platformDetails,
      payload: message.data.toString(),
    );
  }
}
