import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/add_post/components/location_sheet.dart';
import 'package:mejor_oferta/views/add_post/controller/add_post_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:unicons/unicons.dart';

class LocationStep extends GetView<AddPostController> {
  const LocationStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select location",
            style: headline3,
          ),
          const SizedBox(height: 5),
          Text(
            "Where are you selling this item",
            style: text2,
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: () {
              Get.bottomSheet(const LocationSheet(), isScrollControlled: true);
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
                      const Icon(
                        UniconsLine.location_point,
                        color: kWhiteColor8,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        controller.location.value?.name ?? " Location",
                        style: text1.copyWith(color: kWhiteColor4),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Obx(
            () {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: controller.location.value == null
                          ? null
                          : () async {
                              Get.dialog(
                                const Center(
                                  child: CircularProgressIndicator(
                                    color: kPrimaryColor,
                                  ),
                                ),
                                barrierDismissible: false,
                              );
                              await controller.getBrands();
                              await controller.getAttributes();
                              Get.back();
                              controller.next();
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        textStyle: headline3,
                      ),
                      child: const Text("Next"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
