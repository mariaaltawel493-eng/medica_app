import 'dart:developer';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:medica_app/core/routing/routes.dart';
import 'package:medica_app/main.dart';

/// 🔔 معالج استقبال الإشعارات والتطبيق مغلق تماماً (Terminated) أو في الخلفية.
/// ⚠️ يجب أن تكون top-level function (وليست داخل الكلاس) لأن Firebase
/// تُنفّذها في Isolate منفصل عن التطبيق الأساسي.
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  log(
    '🔔 FCM: استقبلنا إشعاراً والتطبيق في الخلفية/مغلق: ${message.notification?.title}',
  );
}

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

    // 🎯 تسجيل معالج الخلفية (Terminated / Background) — يجب أن يتم قبل
    // أي مستمع آخر وقبل runApp لضمان استقبال الإشعارات حتى والتطبيق مغلق
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // إعدادات الأندرويد الأساسية للأيقونة
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    await _localNotificationsPlugin.initialize(
      settings: initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        log('🔔 FCM: تم الضغط على الإشعار المحلي: ${response.payload}');
        // 🎯 حسب الـ Flow اقر: نفتح HistoryScreen مباشرة، وسجل الإشعارات هو
        // من يتولى التنقل الدقيق حسب type عند الضغط داخل السجل نفسه
        navigatorKey.currentState?.pushNamed(Routes.Historyscreen);
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
      navigatorKey.currentState?.pushNamed(Routes.Historyscreen);
    });

    // [المستمع الثالث]: تحديث الـ FCM Token على السيرفر عند تجدده
    // 🛑 TODO: بانتظار تأكيد وجود Endpoint مخصص لتحديث fcm_token بشكل مستقل
    // (الحالي يُرسَل فقط ضمن طلبَي تسجيل الدخول/التسجيل) قبل ربطه بالـ API
    _firebaseMessaging.onTokenRefresh.listen((String newToken) {
      log('🔔 FCM: تم تجديد الـ Token: $newToken');
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
