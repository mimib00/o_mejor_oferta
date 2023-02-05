import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/controller/search_controller.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/loading.dart';
import 'package:mejor_oferta/views/inbox/components/inbox_tile.dart';
import 'package:mejor_oferta/views/inbox/controller/chat_controller.dart';
import 'package:unicons/unicons.dart';

class Inbox extends GetView<ChatController> {
  const Inbox({super.key});

  @override
  Widget build(BuildContext context) {
    controller.messages.clear();
    return Scaffold(
      appBar: AppBar(
        title: Text("inbox_title".tr),
      ),
      body: FutureBuilder(
        future: controller.getThreads(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Loading());
          if (controller.threads.isEmpty) return Container();
          return Obx(
            () {
              final threads = controller.threads.toList();
              final SearchController searchController = Get.put(SearchController());
              searchController.thread = threads;

              return Column(
                children: [
                  Container(
                    // margin: const EdgeInsets.only(top: 50),
                    padding: const EdgeInsets.all(8),
                    color: Colors.white,
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          UniconsLine.search,
                          color: kPrimaryColor,
                        ),
                        hintText: "search".tr,
                        isDense: true,
                        border:
                            OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                        fillColor: kPrimaryColor5,
                        filled: true,
                      ),
                      onChanged: (value) {
                        searchController.threadQuery.value = value;
                      },
                    ),
                  ),
                  ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: searchController.threads.isEmpty ? threads.length : searchController.threads.length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (searchController.threads.isEmpty) {
                        return InboxTile(thread: threads[index]);
                      } else {
                        return InboxTile(thread: searchController.threads[index]);
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
