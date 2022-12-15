import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class Loader {
  Loader._init();

  static final Loader instance = Loader._init();

  void showCircularProgressIndicator() {
    Get.dialog(
      const Center(
        child: CircularProgressIndicator(
          color: kPrimaryColor,
        ),
      ),
      barrierDismissible: false,
    );
  }

  void showCircularProgressIndicatorWithText() {
    Get.dialog(
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: EdgeInsets.symmetric(horizontal: 10.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Material(
              color: Colors.transparent,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Loading",
                    style: text2.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(width: 3.w),
                  const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      color: kPrimaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }
}
