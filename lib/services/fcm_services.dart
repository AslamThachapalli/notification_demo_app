import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../keys.dart';

class Fcm {
  static String? mToken = " ";
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> requestPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      log('User granted permissions');
    } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
      log('User granted provisional permission');
    } else {
      log('User declined or has not granted permissions');
    }
  }

  static Future<void> getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      mToken = token;
    });
  }

  static Future<void> saveToken() async {
    await FirebaseFirestore.instance.collection('UserTokens').doc('User1').set({
      'token': mToken,
    });
  }

  static Future initializeFcm() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      log('on message: ${message.notification?.title}/${message.notification?.body}');

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        styleInformation: bigTextStyleInformation,
        playSound: true,
        sound: const RawResourceAndroidNotificationSound('notification_sound'),
        importance: Importance.high,
        priority: Priority.high,
      );

      NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);

      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        notificationDetails,
        payload: message.data['title'],
      );
    });
  }

  static Future<void> sendPushNotification(
    String token,
    String title,
    String body,
  ) async {
    try {
      await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
          headers: <String, String>{
            'Content-Type': 'application/json',
            'Authorization': serverKey,
          },
          body: jsonEncode(
            <String, dynamic>{
              'priority': 'high',
              'data': <String, dynamic>{
                'click_action': 'FLUTTER_NOTIFICATION_CLICK',
                'status': 'done',
                'title': title,
                'body': body,
              },
              'notification': <String, dynamic>{
                'title': title,
                'body': body,
                'android_channel_id': 'your_channel_id'
              },
              'to': token,
            },
          ));
    } catch (_) {
      if (kDebugMode) {
        print('error push notification');
      }
    }
  }
}
