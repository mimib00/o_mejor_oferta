import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/splash/controller/splash_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "O Mejor ",
                  style: headline1.copyWith(fontWeight: FontWeight.w700, fontSize: 24.sp),
                ),
                Text(
                  "Oferta",
                  style: headline1.copyWith(fontWeight: FontWeight.w700, fontSize: 24.sp, color: kPrimaryColor),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 30,
            left: 45.w,
            child: const CircularProgressIndicator(color: kPrimaryColor),
          ),
        ],
      ),
    );
  }
}
