import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/add_post/components/location_sheet.dart';
import 'package:mejor_oferta/views/profile/controller/account_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LocationSection extends GetView<AccountController> {
  const LocationSection({super.key});

  @override
  Widget build(BuildContext context) {
    String? text = Get.arguments;
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 3.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "You location",
              style: headline3,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Get.bottomSheet(LocationSheet(
                  onTap: (state) {
                    controller.location.value = state.name;
                    controller.update();
                  },
                ), isScrollControlled: true);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: kWhiteColor3),
                ),
                child: Obx(
                  () {
                    return Row(
                      children: [
                        const SizedBox(width: 10),
                        Text(
                          controller.location.value.isEmpty ? text ?? " Location" : controller.location.value,
                          style: text1.copyWith(color: kWhiteColor4),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 5.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (controller.location.value.isNotEmpty) {
                        controller.updateUser(
                          {
                            "location": controller.location.value.trim(),
                          },
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      textStyle: headline3,
                    ),
                    child: const Text("Update"),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
