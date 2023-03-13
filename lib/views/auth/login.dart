import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/text_input.dart';
import 'package:mejor_oferta/views/auth/controller/login_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("login_title".tr),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Form(
            key: controller.loginForm,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 2.h),
                CustomTextInput(
                  controller: controller.email,
                  labelText: "email_title".tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Field required";
                    if (!value.trim().isEmail) return "Email miss formatted";
                    return null;
                  },
                ),
                CustomTextInput(
                  controller: controller.password,
                  labelText: "password_title".tr,
                  obscure: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Field required";
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => Get.toNamed(Routes.forgot),
                  child: Text(
                    "forgot_pass_btn".tr,
                    style: text1.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 15.h),
                Wrap(
                  children: [
                    Text("${'continue_msg'.tr} ", style: text1.copyWith(fontWeight: FontWeight.w400)),
                    GestureDetector(
                      onTap: () => launchUrl(Uri.parse('https://omejorofertapr.com/terms-of-service')),
                      child: Text("${'terms_title'.tr} ", style: text1.copyWith(color: kPrimaryColor)),
                    ),
                    Text("${'and_msg'.tr} ", style: text1.copyWith(fontWeight: FontWeight.w400)),
                    GestureDetector(
                      onTap: () => launchUrl(Uri.parse('https://omejorofertapr.com/privacy-policies')),
                      child: Text("${'policy_title'.tr}.", style: text1.copyWith(color: kPrimaryColor)),
                    ),
                  ],
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (controller.loginForm.currentState!.validate()) {
                          final data = {
                            "email": controller.email.text.trim(),
                            "password": controller.password.text.trim(),
                          };

                          Authenticator.instance.login(data);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10),
                        textStyle: headline3.copyWith(fontWeight: FontWeight.bold),
                      ),
                      child: Text("login_btn".tr),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "${'no_account_msg'.tr} ",
                      style: headline3,
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.register),
                      child: Text(
                        "sign_up_title".tr,
                        style: headline3.copyWith(color: kPrimaryColor, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
