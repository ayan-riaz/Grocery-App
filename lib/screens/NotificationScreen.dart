import 'package:flutter/material.dart';
import 'package:food_app/model/AppNotification.dart';

class NotificationScreen extends StatelessWidget {
  final List<AppNotification> notifications;

  const NotificationScreen({required this.notifications, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:const Text("Notifications")),
      body: ListView.builder(
        itemCount: notifications.length,
        itemBuilder: (context, index) {
          final notif = notifications[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 80,
              decoration: BoxDecoration(
                color:  const Color.fromARGB(55, 0, 0, 0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(notif.title ?? "No title"),
                    const SizedBox(height: 5),
                    Text(notif.body ?? "No body"),
                  ],
                ),
              ),
            )
          );
        },
      ),
    );
  }
}
