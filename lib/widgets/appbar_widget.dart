import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey,
            Colors.grey.shade300,
          ],
        ),
      ),
      child: Center(
        child: Text(
          title,
          style: TextStyle(
            color: Colors.blueGrey.shade400,
            fontSize: 25,
            fontWeight: FontWeight.w600,
            letterSpacing: 3,
          ),
        ),
      ),
    );
  }
}
