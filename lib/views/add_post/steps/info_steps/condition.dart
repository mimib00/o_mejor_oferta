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
                "Select Condition",
                style: headline3,
              ),
              const SizedBox(height: 5),
              Text(
                "What is the condition of your item?",
                style: text2,
              ),
              const SizedBox(height: 20),
              ConditionTile(
                title: "New",
                description: "Select only if the item is brand new.",
                selected: controller.condition.value == "New",
                onTap: (value) {
                  controller.condition.value = value;
                  controller.update();
                },
              ),
              ConditionTile(
                title: "Used",
                description: "Select only if the item has been used before.",
                selected: controller.condition.value == "Used",
                onTap: (value) {
                  controller.condition.value = value;
                  controller.update();
                },
              ),
              ConditionTile(
                title: "Used - Like New",
                description: "Select only if the item has been used before but look new.",
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
                      onPressed: controller.condition.value.isEmpty ? null : () => controller.next(),
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
