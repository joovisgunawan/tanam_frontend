import 'package:flutter/material.dart';
import 'package:tanam/models/notificationmodel.dart';

class NotificationDetailScreen extends StatefulWidget {
  final NotificationModel notif;

  const NotificationDetailScreen({super.key, required this.notif});

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  @override
  Widget build(BuildContext context) {
    // final message = ModalRoute.of(context)!.settings.arguments as RemoteMessage;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Text(
                widget.notif.title.toString(),
              ),
              // Text(message.notification!.title.toString())
            ],
          )
        ],
      ),
    );
  }
}
