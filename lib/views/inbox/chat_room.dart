import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/loading.dart';
import 'package:mejor_oferta/views/inbox/components/chat_bubble.dart';
import 'package:mejor_oferta/views/inbox/controller/chat_controller.dart';

class ChatRoom extends GetView<ChatController> {
  const ChatRoom({super.key});

  @override
  Widget build(BuildContext context) {
    final id = Get.parameters["id"];
    final name = Get.parameters["name"];
    final uid = Get.parameters["uid"];

    return Scaffold(
      appBar: AppBar(
        title: Text(name!),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.more_vert_rounded),
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: controller.getChatRoom(id!),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Loading());
                return Obx(
                  () {
                    if (controller.messages.isEmpty) return Container();
                    final messages = controller.messages.reversed.toList();
                    return ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: messages.length,
                      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                      reverse: true,
                      itemBuilder: (context, index) {
                        return ChatBubble(message: messages[index]);
                      },
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
              width: double.infinity,
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(color: kWhiteColor3),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: controller.input,
                      decoration: InputDecoration(
                        hintText: "Type your message",
                        hintStyle: text1,
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(180),
                          borderSide: const BorderSide(color: kWhiteColor3),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(180),
                          borderSide: const BorderSide(color: kWhiteColor3),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(180),
                          borderSide: const BorderSide(color: kWhiteColor3),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      if (controller.input.text.trim().isEmpty) return;
                      final me = Authenticator.instance.user.value!;
                      final data = {
                        'message': controller.input.text.trim(),
                        'sent_by': me.id,
                        'send_to': uid,
                        'thread_id': id,
                      };
                      controller.sendMessage(data);
                    },
                    icon: const Icon(Icons.send),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}