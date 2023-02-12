import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/add_post/components/condition_tile.dart';
import 'package:mejor_oferta/views/add_post/controller/add_post_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ConditionStep extends GetView<AddPostController> {
  const ConditionStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 3.h),
      child: Obx(
        () {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "condition_title".tr,
                style: headline3,
              ),
              const SizedBox(height: 5),
              Text(
                "condition_msg".tr,
                style: text2,
              ),
              const SizedBox(height: 20),
              ConditionTile(
                title: "new_title".tr,
                description: "new_msg".tr,
                selected: controller.condition.value == "New",
                onTap: (value) {
                  controller.condition.value = value;
                  controller.update();
                },
              ),
              ConditionTile(
                title: "used_title".tr,
                description: "used_msg".tr,
                selected: controller.condition.value == "Used",
                onTap: (value) {
                  controller.condition.value = value;
                  controller.update();
                },
              ),
              ConditionTile(
                title: "like_new_title",
                description: "like_new_msg".tr,
                selected: controller.condition.value == "Used - Like New",
                onTap: (value) {
                  controller.condition.value = value;
                  controller.update();
                },
              ),
              SizedBox(height: 10.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: controller.condition.value.isEmpty ? null : () => controller.nextInfo(),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        textStyle: headline3,
                      ),
                      child: const Text("Next"),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
