import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/add_post/controller/add_post_controller.dart';

class InfoStep extends GetView<AddPostController> {
  const InfoStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: controller.percentage,
              color: kPrimaryColor,
              backgroundColor: kWhiteColor2,
            ),
            Expanded(
              child: controller.infoStep,
            )
          ],
        );
      },
    );
  }
}
