import 'package:flutter/material.dart';
import 'package:notification_app/widgets/appbar_widget.dart';

class PayloadScreen extends StatelessWidget {
  const PayloadScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: AppBarWidget(title: 'Payload Screen'),
      ),
      body: const Center(
        child: Text(
          'The Payload Data Can Be Accessed In This Screen',
          textAlign: TextAlign.center,
          style: TextStyle(
            letterSpacing: 0.5,
            height: 1.25,
            color: Colors.blueGrey,
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
