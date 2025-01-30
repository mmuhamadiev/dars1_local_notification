import 'dart:io';

import 'package:dars1_local_notification/presentation/pages/home_page.dart';
import 'package:flutter/material.dart';

import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // TODO Local Notification setup - 8 - notificationService ni chaqirtirib local notification initialize qilish
  NotificationService notificationService = NotificationService();
  await notificationService.init();
  if(Platform.isAndroid) {
    // TODO Local Notification setup - 9 - android telefonlarda notification ga userdan ruxsat olish
    await notificationService.requestAndroidPermissions();
  }
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Local Notifications Example',
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: HomePage(),
    );
  }
}