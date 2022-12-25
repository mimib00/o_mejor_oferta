import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/text_input.dart';
import 'package:mejor_oferta/views/auth/controller/login_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
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
                  labelText: "Email",
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Field required";
                    if (!value.isEmail) return "Email miss formated";
                    return null;
                  },
                ),
                CustomTextInput(
                  controller: controller.password,
                  labelText: "Password",
                  obscure: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) return "Field required";
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  "Forgot password?",
                  style: headline2.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
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
                      child: const Text("Login"),
                    ),
                  ],
                ),
                SizedBox(height: 3.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don’t have an account? ",
                      style: headline3,
                    ),
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.register),
                      child: Text(
                        "Sign up",
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
