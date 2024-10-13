import 'package:flutter/material.dart';
import 'package:magadige/constants.dart';
import 'package:magadige/models/app.notification.model.dart';
import 'package:magadige/modules/notifications/servie.dart';
import 'package:magadige/utils/index.dart';

class NotificationListView extends StatelessWidget {
  const NotificationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(color: titleGrey),
        ),
      ),
      body: StreamBuilder<List<AppNotification>>(
        stream: NotificationService().getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text('Error loading notifications'));
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No notifications found'));
          }

          final notifications = snapshot.data!;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              return ListTile(
                leading: const Icon(
                  Icons.notifications,
                  color: primaryColor,
                ),
                title: Text(notification.title),
                subtitle: Text(notification.subtitle),
                trailing: Text(
                  notification.dateCreated.formatDate(),
                  style: const TextStyle(fontSize: 12),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
