import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({super.key});

  final GlobalKey<FormState> form = GlobalKey();

  final TextEditingController phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("forgot_pass_title".tr),
      ),
      body: Form(
        key: form,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: phone,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Field required";
                  if (!value.isPhoneNumber) return "Please enter a valid phone number";
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "phone_title".tr,
                  isDense: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: kPrimaryColor5,
                  filled: true,
                ),
              ),
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        if (form.currentState!.validate()) {
                          Get.toNamed(Routes.otp, parameters: {"phone": phone.text.trim(), "signup": "false"});
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10),
                        textStyle: headline3.copyWith(fontWeight: FontWeight.bold),
                      ),
                      child: Text("send_btn".tr),
                    ),
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
