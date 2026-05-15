import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static Function(String id)? onNotificationClick;

  static Future<void> init() async {
    await _messaging.requestPermission();
    tz_data.initializeTimeZones();

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidInit);

    await _local.initialize(
      settings,
      onDidReceiveNotificationResponse: (response) {
        final payload = response.payload;
        if (payload != null && onNotificationClick != null) {
          onNotificationClick!(payload);
        }
      },
    );

    FirebaseMessaging.onMessage.listen(_show);
    FirebaseMessaging.onMessageOpenedApp.listen(_handle);

    final initial = await _messaging.getInitialMessage();
    if (initial != null) {
      _handle(initial);
    }
  }

  static Future<void> _show(RemoteMessage message) async {
    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title ?? 'CureMate',
      message.notification?.body ?? '',
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'curemate_channel',
          'CureMate Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      payload: message.data['prescriptionId'],
    );
  }

  static void _handle(RemoteMessage message) {
    final id = message.data['prescriptionId'];

    if (id != null && onNotificationClick != null) {
      onNotificationClick!(id);
    }
  }

  static Future<void> subscribeUser(String uid) async {
    await _messaging.subscribeToTopic('user_$uid');
  }

  static Future<void> subscribePharmacy() async {
    await _messaging.subscribeToTopic('pharmacy');
  }

  static Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    String? payload,
  }) async {
    final now = DateTime.now();
    var safeTime = dateTime;

    if (safeTime.isBefore(now)) {
      safeTime = safeTime.add(const Duration(days: 1));
    }

    await _local.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(safeTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Medicine Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  static Future<void> saveNotification({
    required String title,
    required String message,
    required String type,
    required String targetId,
  }) async {
    await FirebaseFirestore.instance.collection('notifications').add({
      'title': title,
      'message': message,
      'type': type,
      'targetId': targetId,
      'createdAt': FieldValue.serverTimestamp(),
      'isRead': false,
    });
  }

  static Future<void> markAsRead(String id) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(id)
        .update({'isRead': true});
  }
}
