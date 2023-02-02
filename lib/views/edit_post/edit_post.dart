import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:mejor_oferta/meta/widgets/loading.dart';
import 'package:mejor_oferta/views/edit_post/controller/edit_post_controller.dart';

class EditPost extends GetView<EditPostController> {
  const EditPost({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    Listing listing = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit an ad"),
      ),
      body: FutureBuilder(
        future: controller.getAttributes(listing),
        builder: (context, snapshot) {
          if (controller.infoSteps.isEmpty) return const Center(child: Loading());
          return Obx(
            () {
              return controller.infoStep;
            },
          );
        },
      ),
    );
  }
}
