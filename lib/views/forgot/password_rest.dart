import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/loader.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PasswordReset extends StatelessWidget {
  PasswordReset({super.key});

  final GlobalKey<FormState> form = GlobalKey();

  final TextEditingController password = TextEditingController();
  final TextEditingController confirmPassword = TextEditingController();

  final dio = Dio();

  final phone = Get.parameters["phone"];

  Future<void> resetPassword() async {
    try {
      Loader.instance.showCircularProgressIndicatorWithText();
      const url = "$baseUrl/authentication/users/reset-password/";

      await dio.post(
        url,
        data: {
          "phone_number": phone,
          "password": password.text.trim(),
        },
      );
      Get.back();
      Get.offAllNamed(Routes.login);
    } on DioError catch (e, stackTrace) {
      Get.back();
      debugPrintStack(stackTrace: stackTrace);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e, stackTrace) {
      Get.back();
      log(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Change password"),
      ),
      body: Form(
        key: form,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                controller: password,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Field required";
                  if (value.length < 8) return "Password must be more then 8 characters long";
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Password",
                  isDense: true,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: kPrimaryColor5,
                  filled: true,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: confirmPassword,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Field required";
                  if (value != password.text.trim()) return "Passwords don't match";
                  return null;
                },
                decoration: InputDecoration(
                  hintText: "Confirm Password",
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
                          resetPassword();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10),
                        textStyle: headline3.copyWith(fontWeight: FontWeight.bold),
                      ),
                      child: const Text("Change password"),
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
