import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notification_app/pages/payload_screen.dart';

import '../widgets/appbar_widget.dart';
import '../widgets/button.dart';
import '../widgets/textFieldsList.dart';
import '../services/notification.dart' as not;
import '../services/fcm_services.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({
    Key? key,
    required this.notificationType,
    this.isPushNotification = false,
  }) : super(key: key);

  final String notificationType;
  final bool isPushNotification;

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _bodyController = TextEditingController();
  final TextEditingController _scheduleController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    not.Notification.initialize(
      initScheduled: widget.notificationType == 'Scheduled Notification',
    );
    if (widget.isPushNotification) {
      Fcm.requestPermissions()
          .then(
            (_) => Fcm.getToken(),
          )
          .then(
            (_) => Fcm.saveToken(),
          );
      Fcm.initializeFcm();
    }
    listenNotifications();
  }

  void listenNotifications() {
    not.Notification.onNotifications.stream.listen((payload) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const PayloadScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBarWidget(title: widget.notificationType),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ...textFields(
              notificationType: widget.notificationType,
              bodyController: _bodyController,
              scheduleController: _scheduleController,
              titleController: _titleController,
              userNameController: _userNameController,
            ),
            NeoButton(
              notificationType: 'Start Notification',
              onTap: () async {
                if (widget.notificationType == 'Local Notification') {
                  not.Notification.showLocalNotification(
                    title: _titleController.text,
                    body: _bodyController.text,
                  );

                  _titleController.clear();
                  _bodyController.clear();
                } else if (widget.notificationType == 'Scheduled Notification') {
                  not.Notification.showScheduledNotification(
                    title: _titleController.text,
                    body: _bodyController.text,
                    scheduledTime: DateTime.now().add(
                      Duration(seconds: int.parse(_scheduleController.text)),
                    ),
                  );

                  final snackBar = SnackBar(
                    content: Text(
                      'Scheduled in ${_scheduleController.text} seconds',
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 16),
                    ),
                    backgroundColor: Colors.blueGrey,
                    behavior: SnackBarBehavior.floating,
                    elevation: 1,
                  );

                  ScaffoldMessenger.of(context)
                    ..removeCurrentSnackBar()
                    ..showSnackBar(snackBar);

                  _titleController.clear();
                  _bodyController.clear();
                  _scheduleController.clear();
                } else if (widget.notificationType == 'Push Notification') {
                  String name = _userNameController.text.trim();
                  String title = _titleController.text;
                  String body = _bodyController.text;
                  if (name != "") {
                    DocumentSnapshot snap =
                        await FirebaseFirestore.instance.collection('UserTokens').doc(name).get();
                    String token = snap['token'];

                    Fcm.sendPushNotification(token, title, body);
                  }
                  _userNameController.clear();
                  _titleController.clear();
                  _bodyController.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
