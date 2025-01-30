// TODO Local Notification setup - 7 - import flutter_local_notifications and timezone
import 'package:dars1_local_notification/main.dart';
import 'package:dars1_local_notification/presentation/pages/details_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

// TODO Local Notification setup - 7 - class yaratamiz
class NotificationService {

  // TODO Local Notification setup - 7 - local notification plugini tayorlab olamiz
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  // TODO Local Notification setup - 7 - chanell bu androida qaysi yonalish boicha notification android kod orqali flutterga yetqasiz beradi
  static const channelId = "1";
  static const channelName = "local_notification_template";

  // TODO Local Notification setup - 7 - channel setup
  static const AndroidNotificationChannel _androidNotificationChannel =
  AndroidNotificationChannel(
    channelId,
    channelName,
    description: "This channel is responsible for all the local notifications",
    importance: Importance.high,
    playSound: true,
  );

  // TODO Local Notification setup - 7 - init funkciya yaratib uni main dart da chaqirtiramiz\
  Future<void> init() async {
    if(isInitialized) return;
    // Initialize timezone
    tz.initializeTimeZones();

    // Initialize Android settings
    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings('@mipmap/launcher_icon');

    // Initialize iOS settings
    const DarwinInitializationSettings iOSInitializationSettings =
    DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // Initialize global settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    // Create the notification channel
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidNotificationChannel);

    // Initialize the plugin
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );
  }
  // TODO Local Notification setup - 7 - android da notification qabul qilish uchun ruxsat sorash funkciyasi
  Future<void> requestAndroidPermissions() async {
    await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()!.requestNotificationsPermission();
  }

  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
          channelId,
          channelName,
        channelDescription: 'Local Notification Template',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails()
    );
  }

  // TODO Local Notification setup - 7 - bir martalik notification korsatish
  Future<void> showNotification(
      int id, String title, String body, String payload) async {
    NotificationDetails notificationDetail = notificationDetails();

    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      notificationDetail,
      payload: payload,
    );
  }

  // TODO Local Notification setup - 7 - belgilangan vaqt da notification korstish
  Future<void> scheduleNotification(int id, String title, String body,
      DateTime eventDate, TimeOfDay eventTime, String payload,
      [DateTimeComponents? dateTimeComponents]) async {
    final scheduledTime = eventDate.add(Duration(
      hours: eventTime.hour,
      minutes: eventTime.minute,
    ));

    NotificationDetails notificationDetail = notificationDetails();

    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      notificationDetail,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
      matchDateTimeComponents: dateTimeComponents,
    );
  }

  // TODO Local Notification setup - 7 - har bir minut, yoki har bir sogot va shunaqa tipdagi notification korsatish
  Future<void> schedulePeriodicNotification(int id, String title, String body,
      RepeatInterval repeatInterval, String payload) async {

    NotificationDetails notificationDetail = notificationDetails();

    await flutterLocalNotificationsPlugin.periodicallyShow(
      id,
      title,
      body,
      repeatInterval,
      notificationDetail,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  // TODO Local Notification setup - 7 - id orqali notification toxtatish
  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);
  }

  // TODO Local Notification setup - 7 - xamma notification larni toxtatish
  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

// TODO Local Notification setup - 7 - notification ga bosganda unin malumotini korish ekraniga otish
// Callback for when a notification is tapped
Future<void> onDidReceiveNotificationResponse(
    NotificationResponse notificationResponse) async {
  if (notificationResponse.payload != null) {
    await navigatorKey.currentState?.push(MaterialPageRoute(
        builder: (_) => DetailsPage(payload: notificationResponse.payload)));
  }
}