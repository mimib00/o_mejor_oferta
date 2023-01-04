import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/controller/notification_controller.dart';
import 'package:mejor_oferta/meta/models/notification.dart';
import 'package:mejor_oferta/meta/widgets/loading.dart';
import 'package:mejor_oferta/views/notifications/components/notification_tile.dart';

class NotificationScreen extends GetView<NotificationController> {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notifications"),
      ),
      body: FutureBuilder<List<NotificationMessage>>(
        future: controller.getNotifications(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Loading());
          if (snapshot.data == null || snapshot.data!.isEmpty) return Container();

          final messages = snapshot.data!;
          return ListView.builder(
            itemCount: messages.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return NotificationTile(
                notification: messages[index],
              );
            },
          );
        },
      ),
    );
  }
}
