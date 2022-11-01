import 'package:flutter/material.dart';

import 'notification_screen.dart';
import '../widgets/appbar_widget.dart';
import '../widgets/button.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBarWidget(title: 'Notification Demo App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            NeoButton(
              notificationType: 'Local Notification',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(
                      notificationType: 'Local Notification',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            NeoButton(
              notificationType: 'Scheduled Notification',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(
                      notificationType: 'Scheduled Notification',
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            NeoButton(
              notificationType: 'Push Notification',
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const NotificationScreen(
                      notificationType: 'Push Notification',
                      isPushNotification: true,
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
