import 'package:flutter/material.dart';

class NotificationDetailScreen2 extends StatelessWidget {
  final Map<String, dynamic> notif;

  const NotificationDetailScreen2({super.key, required this.notif});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          notif['title'],
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.green, // Example color
        elevation: 0, // No shadow
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              notif['body'],
              style: const TextStyle(
                fontSize: 18,
                height: 1.4, // Adjust line height
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
