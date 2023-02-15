import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/views/add_post/controller/add_post_controller.dart';

class AddPost extends GetView<AddPostController> {
  const AddPost({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          appBar: AppBar(
            title: Text("post_ad_title".tr),
            leading: IconButton(
              onPressed: () {
                if (controller.stepIndex.value == 0) {
                  Get.back();
                } else if (controller.stepIndex.value > 0) {
                  controller.back();
                } else if (controller.infoStepIndex.value == 0) {
                  controller.back();
                } else if (controller.infoStepIndex.value > 0) {
                  controller.backInfo();
                }
              },
              icon: const Icon(Icons.arrow_back_ios_new_rounded),
            ),
          ),
          body: controller.step,
        );
      },
    );
  }
}
