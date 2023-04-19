import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/notification.dart';

class NotificationController extends GetxController {
  final dio = Dio();
  Future<List<NotificationMessage>> getNotifications() async {
    try {
      const url = "$baseUrl/notifications/notifications/";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      List<NotificationMessage> messages = [];
      for (var message in res.data) {
        messages.add(NotificationMessage.fromJson(message));
      }
      return messages;
    } on DioError catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e, stackTrace) {
      log(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      Fluttertoast.showToast(msg: e.toString());
    }
    return [];
  }

  // Notification Config
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    //Initialization Settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    //Initialization Settings for iOS
    final DarwinInitializationSettings initializationSettingsIOS = DarwinInitializationSettings(
      defaultPresentSound: true,
      defaultPresentBadge: true,
      defaultPresentAlert: true,
      onDidReceiveLocalNotification: (id, title, body, payload) => showNotifications(title, body),
    );

    //InitializationSettings for initializing settings for both platforms (Android & iOS)
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    Platform.isAndroid
        ? await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()!.requestPermission()
        : await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()!
            .requestPermissions(alert: true, sound: true, badge: true);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      log(message.sentTime.toString());
      if (message.notification != null) {
        log(message.notification!.title.toString());
        showNotifications(message.notification?.title, message.notification?.body);
      }
    });
  }

  static const AndroidNotificationDetails _androidNotificationDetails = AndroidNotificationDetails(
    '0',
    'myChannel',
    playSound: true,
    priority: Priority.high,
    importance: Importance.high,
    color: Colors.white,
    enableLights: true,
  );

  static const DarwinNotificationDetails _darwinNotificationDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  Future<void> showNotifications(String? title, String? body) async {
    await flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      const NotificationDetails(android: _androidNotificationDetails, iOS: _darwinNotificationDetails),
    );
  }

  @override
  void onInit() async {
    await init();

    super.onInit();
  }
}
