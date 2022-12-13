import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/main_button.dart';
import 'package:mejor_oferta/views/OTP/controller/otp_controller.dart';
import 'package:pinput/pinput.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OtpScreen extends GetView<OtpController> {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 2.h),
              Text("Enter authentication code", style: headline1),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  "Enter the 6-digit that we have sent via the phone number ${controller.phone}",
                  style: headline3.copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 10.h),
              Pinput(
                length: 6,
                onCompleted: (value) async {
                  controller.code = value;
                  await controller.verifyOtp();
                },
                defaultPinTheme: PinTheme(
                  height: 50,
                  width: 50,
                  textStyle: const TextStyle(color: kPrimaryColor),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kWhiteColor2,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                focusedPinTheme: PinTheme(
                  height: 50,
                  width: 50,
                  textStyle: const TextStyle(color: kPrimaryColor),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: kPrimaryColor,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(height: 10.h),
              Obx(
                () {
                  return Visibility(
                    visible: controller.valid.value,
                    child: MainButton(
                      onTap: () {
                        Authenticator.instance.signup(
                          {
                            "name": controller.name,
                            "email": controller.email,
                            "phone_number": controller.phone,
                            "password": controller.password,
                          },
                        );
                      },
                      text: "Continue",
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}