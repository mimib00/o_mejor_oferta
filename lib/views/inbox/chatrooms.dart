import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/models/chat.dart';
import 'package:mejor_oferta/meta/widgets/loading.dart';
import 'package:mejor_oferta/views/inbox/components/inbox_tile.dart';
import 'package:mejor_oferta/views/inbox/controller/chat_controller.dart';

class Inbox extends GetView<ChatController> {
  const Inbox({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inbox"),
      ),
      body: FutureBuilder<List<InboxThread>>(
        future: controller.getThreads(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Loading());
          if (snapshot.data == null || snapshot.data!.isEmpty) return Container();
          final threads = snapshot.data!;
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: threads.length,
            itemBuilder: (context, index) {
              return InboxTile(thread: threads[index]);
            },
          );
        },
      ),
    );
  }
}
