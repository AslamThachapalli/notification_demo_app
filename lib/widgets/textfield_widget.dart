import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    required this.hintText,
    required this.controller,
  }) : super(key: key);

  final String hintText;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: TextField(
        controller: controller,
        keyboardType: hintText == 'schedule in seconds' ? TextInputType.number : null,
        decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(color: Colors.blueGrey.shade300),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(color: Colors.transparent),
            ),
            filled: true,
            fillColor: Colors.blueGrey.shade100),
      ),
    );
  }
}
