/*import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  /// CLICK CALLBACK
  static Function(String id)? onNotificationClick;

  /// INIT
  static Future<void> init() async {
    await _messaging.requestPermission();

    /// timezone init (IMPORTANT for alarms)
    tz.initializeTimeZones();

    final token = await _messaging.getToken();
    print("FCM TOKEN: $token");

    /// FOREGROUND messages
    FirebaseMessaging.onMessage.listen((message) {
      _showFCM(message);
    });

    /// BACKGROUND click
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handleClick(message);
    });

    /// LOCAL NOTIFICATION INIT
    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

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

    /// KILLED STATE CLICK
    final initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleClick(initialMessage);
    }
  }

  
  ///  FCM SHOW
  
  static Future<void> _showFCM(RemoteMessage message) async {
    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title ?? "CureMate",
      message.notification?.body ?? "",
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'curemate_channel',
          'CureMate Notifications',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
    );
  }

  
  ///  SCHEDULE LOCAL REMINDER
  
  static Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    String? payload,
  }) async {

 final now = DateTime.now();
  DateTime safeDateTime = dateTime;

  if (safeDateTime.isBefore(now)) {
    safeDateTime = safeDateTime.add(const Duration(days: 1));
  }

    await _local.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'reminder_channel',
          'Medicine Reminders',
          importance: Importance.max,
          priority: Priority.high,
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  
  /// CLICK HANDLER (FCM)
  
  static void _handleClick(RemoteMessage message) {
    final id = message.data['prescriptionId'];

    if (id != null && onNotificationClick != null) {
      onNotificationClick!(id);
    }
  }

  
  /// TOPICS
  
  static Future<void> subscribeUser(String uid) async {
    await _messaging.subscribeToTopic("user_$uid");
  }

  static Future<void> subscribePharmacy() async {
    await _messaging.subscribeToTopic("pharmacy");
  }

 
  /// FIRESTORE SAVE
  
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

  /// MARK AS READ
  static Future<void> markAsRead(String id) async {
    await FirebaseFirestore.instance
        .collection('notifications')
        .doc(id)
        .update({'isRead': true});
  }
}*/


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _local =
      FlutterLocalNotificationsPlugin();

  static Function(String id)? onNotificationClick;

  /// INIT
  static Future<void> init() async {
    await _messaging.requestPermission();

    const androidInit =
        AndroidInitializationSettings('@mipmap/ic_launcher');

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

    /// FOREGROUND
    FirebaseMessaging.onMessage.listen((message) {
      _show(message);
    });

    /// BACKGROUND TAP
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      _handle(message);
    });

    /// TERMINATED STATE
    final initial = await _messaging.getInitialMessage();
    if (initial != null) _handle(initial);
  }

  /// SHOW LOCAL NOTIFICATION
  static Future<void> _show(RemoteMessage message) async {
    await _local.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      message.notification?.title ?? "CureMate",
      message.notification?.body ?? "",
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

  /// HANDLE CLICK
  static void _handle(RemoteMessage message) {
    final id = message.data['prescriptionId'];

    if (id != null && onNotificationClick != null) {
      onNotificationClick!(id);
    }
  }

  /// USER TOPIC
  static Future<void> subscribeUser(String uid) async {
    await _messaging.subscribeToTopic("user_$uid");
  }

  /// PHARMACY TOPIC
  static Future<void> subscribePharmacy() async {
    await _messaging.subscribeToTopic("pharmacy");
  }

//REMINDER NOTIFICATION 

static Future<void> scheduleReminder({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
    String? payload,
  }) async {
    final now = DateTime.now();
    DateTime safeTime = dateTime;

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

}
