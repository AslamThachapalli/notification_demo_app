import 'package:flutter/material.dart';

import 'textfield_widget.dart';

List<Widget> textFields({
  required String notificationType,
  required TextEditingController userNameController,
  required TextEditingController titleController,
  required TextEditingController bodyController,
  required TextEditingController scheduleController,
}) {
  return [
    if (notificationType == 'Push Notification')
      TextFieldWidget(
        hintText: 'User Name',
        controller: userNameController,
      ),
    if (notificationType == 'Push Notification') const SizedBox(height: 20),
    TextFieldWidget(
      hintText: 'title',
      controller: titleController,
    ),
    const SizedBox(height: 20),
    TextFieldWidget(
      hintText: 'body',
      controller: bodyController,
    ),
    const SizedBox(height: 20),
    if (notificationType == 'Scheduled Notification')
      TextFieldWidget(
        hintText: 'schedule in seconds',
        controller: scheduleController,
      ),
    if (notificationType == 'Scheduled Notification') const SizedBox(height: 20),
  ];
}
