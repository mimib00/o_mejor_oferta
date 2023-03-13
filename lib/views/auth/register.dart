import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/text_input.dart';
import 'package:mejor_oferta/views/auth/controller/register_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("sign_up_title".tr),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 3.w),
          child: Form(
            key: controller.registerForm,
            child: Column(
              children: [
                CustomTextInput(
                  controller: controller.name,
                  labelText: "name_title".tr,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Field required";
                    return null;
                  },
                ),
                CustomTextInput(
                  controller: controller.email,
                  labelText: "Email",
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Field required";
                    if (!value.trim().isEmail) return "Email miss formatted";
                    return null;
                  },
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: kWhiteColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xffE3E5E5), width: 1),
                  ),
                  child: InternationalPhoneNumberInput(
                    countries: const ["US"],
                    validator: (value) {
                      if (value == null || value.isEmpty) return "Field required";
                      if (!value.trim().isPhoneNumber) return "Please enter a valid phone number";
                      return null;
                    },
                    onInputChanged: (value) {
                      controller.phone = value.phoneNumber ?? "";
                    },
                    inputDecoration: const InputDecoration(
                      hintText: "xxx-xxx-xxxx",
                    ),
                  ),
                ),
                CustomTextInput(
                  controller: controller.password,
                  labelText: "password_title".tr,
                  obscure: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Field required";
                    if (value.length < 8) return "Password must be more then 8 characters long";
                    if (value.isNumericOnly) return "Password must be Alphanumeric";
                    return null;
                  },
                ),
                CustomTextInput(
                  controller: null,
                  labelText: "conf_password_title".tr,
                  obscure: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Field required";
                    if (value != controller.password.text.trim()) return "Passwords don't match";
                    return null;
                  },
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
                        if (controller.registerForm.currentState!.validate()) {
                          Get.toNamed(
                            Routes.otp,
                            parameters: {
                              "signup": "true",
                              "phone": controller.phone.trim(),
                              "name": controller.name.text.trim(),
                              "email": controller.email.text.trim(),
                              "password": controller.password.text.trim(),
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10),
                        textStyle: headline3.copyWith(fontWeight: FontWeight.bold),
                      ),
                      child: Text("sign_up_title".tr),
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
