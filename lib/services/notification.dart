import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import 'utils.dart';

class Notification {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();

  static Future initialize({bool initScheduled = false}) async {
    const AndroidInitializationSettings androidInitialization =
        AndroidInitializationSettings('mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitialization,
    );

    //when app is closed
    final details = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (details != null && details.didNotificationLaunchApp) {
      onNotifications.add(details.notificationResponse!.payload);
    }

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (notificationResponse) =>
          onNotifications.add(notificationResponse.payload),
    );

    if (initScheduled) {
      tz.initializeTimeZones();
      final locationName = await FlutterNativeTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(locationName));
    }
  }

  static Future<NotificationDetails> notificationDetails() async {
    final largeIconPath = await Utils.downloadFile(
      'https://images.pexels.com/photos/7149036/pexels-photo-7149036.jpeg?auto=compress&cs=tinysrgb&w=600',
      'largeIcon',
    );
    final bigPicturePath = await Utils.downloadFile(
      'https://images.pexels.com/photos/3565850/pexels-photo-3565850.jpeg?auto=compress&cs=tinysrgb&w=600',
      'bigPicture',
    );
    final styleInformation = BigPictureStyleInformation(
      FilePathAndroidBitmap(bigPicturePath!),
      largeIcon: FilePathAndroidBitmap(largeIconPath!),
    );

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your channel description',
      styleInformation: styleInformation,
      playSound: true,
      sound: const RawResourceAndroidNotificationSound('notification_sound'),
      importance: Importance.max,
      priority: Priority.high,
    );
    NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    return notificationDetails;
  }

  static Future showLocalNotification({
    var id = 0,
    required String title,
    required String body,
    var payload,
  }) async {
    await flutterLocalNotificationsPlugin.show(id, title, body, await notificationDetails());
  }

  static Future showScheduledNotification({
    var id = 0,
    required String title,
    required String body,
    var payload,
    required DateTime scheduledTime,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledTime, tz.local),
      await notificationDetails(),
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    );
  }
}
