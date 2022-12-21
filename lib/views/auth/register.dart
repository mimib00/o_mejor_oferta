import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/main_button.dart';
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
                    if (!value.contains(" ")) return "Must provide First and last name";
                    return null;
                  },
                ),
                CustomTextInput(
                  controller: controller.email,
                  labelText: "Email",
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Field required";
                    if (!value.isEmail) return "Email miss formated";
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
                  child: IntlPhoneField(
                    initialCountryCode: "DZ",
                    validator: (phone) {
                      if (phone == null || phone.number.isEmpty) return "Field required";
                      return null;
                    },
                    keyboardType: TextInputType.phone,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      counterText: "",
                      hintText: "Phone number",
                    ),
                    onChanged: (value) => controller.phone = value.completeNumber,
                  ),
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
                    Text("Terms of Service ", style: headline3.copyWith(color: kPrimaryColor)),
                    Text("and ", style: headline3.copyWith(fontWeight: FontWeight.w400)),
                    Text("Privacy Policy.", style: headline3.copyWith(color: kPrimaryColor)),
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
                      child: const Text("Sign Up"),
                    ),
                  ],
                ),
                // MainButton(
                //   onTap: () {
                //     if (controller.registerForm.currentState!.validate()) {
                //       Get.toNamed(
                //         Routes.otp,
                //         parameters: {
                //           "signup": "true",
                //           "phone": controller.phone.trim(),
                //           "name": controller.name.text.trim(),
                //           "email": controller.email.text.trim(),
                //           "password": controller.password.text.trim(),
                //         },
                //       );
                //     }
                //   },
                //   text: "Sign Up",
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
