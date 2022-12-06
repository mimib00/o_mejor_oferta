import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/main_button.dart';
import 'package:mejor_oferta/meta/widgets/text_input.dart';
import 'package:mejor_oferta/views/auth/controller/auth_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LoginScreen extends GetView<AuthController> {
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 15.h),
              TextInput(
                controller: controller.email,
                labelText: "Email",
              ),
              TextInput(
                controller: controller.email,
                labelText: "Password",
                obscure: true,
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
              MainButton(onTap: () {}, text: "Login"),
              SizedBox(height: 10.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don’t have an account? ",
                    style: headline3,
                  ),
                  Text(
                    "Sign up",
                    style: headline3.copyWith(color: kPrimaryColor, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
