import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/text_input.dart';
import 'package:mejor_oferta/views/auth/controller/register_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RegisterScreen extends GetView<RegisterController> {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign up"),
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
                  labelText: "Name",
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
                    if (!value.isEmail) return "Email miss formatted";
                    return null;
                  },
                ),
                CustomTextInput(
                  controller: controller.phone,
                  labelText: "Ex: +92123456789",
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Field required";
                    if (!value.isPhoneNumber) return "Please enter a valid phone number";
                    return null;
                  },
                ),
                CustomTextInput(
                  controller: controller.password,
                  labelText: "Password",
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
                  labelText: "Confirm Password",
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
                    Text("By continuing, you agree to our ", style: headline3.copyWith(fontWeight: FontWeight.w400)),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.terms),
                      child: Text("Terms of Service ", style: headline3.copyWith(color: kPrimaryColor)),
                    ),
                    Text("and ", style: headline3.copyWith(fontWeight: FontWeight.w400)),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.policy),
                      child: Text("Privacy Policy.", style: text1.copyWith(color: kPrimaryColor)),
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
                              "phone": controller.phone.text.trim(),
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
                      child: const Text("Sign Up"),
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
