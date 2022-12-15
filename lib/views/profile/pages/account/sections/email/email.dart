import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/text_input.dart';
import 'package:mejor_oferta/views/profile/controller/account_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class EmailSection extends GetView<AccountController> {
  EmailSection({super.key});

  final TextEditingController input = TextEditingController();

  final GlobalKey<FormState> form = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final text = Get.arguments.toString();
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 3.w),
        child: Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 2.h),
              Text(
                "Your Email",
                style: text2.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: .5.h),
              CustomTextInput(
                controller: input,
                labelText: "Email",
                hintText: text,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Field required";
                  return null;
                },
              ),
              SizedBox(height: 4.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (form.currentState!.validate()) {
                          controller.updateUser(
                            {
                              "email": input.text.trim(),
                            },
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        textStyle: headline3,
                      ),
                      child: const Text("Update"),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
