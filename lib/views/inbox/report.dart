import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/loader.dart';
import 'package:mejor_oferta/meta/widgets/text_input.dart';

class ChatReport extends StatefulWidget {
  const ChatReport({super.key});

  @override
  State<ChatReport> createState() => _ChatReportState();
}

class _ChatReportState extends State<ChatReport> {
  String reson = "Select";

  final GlobalKey<FormState> form = GlobalKey();

  final TextEditingController email = TextEditingController();
  final TextEditingController message = TextEditingController();

  final dio = Dio();

  Future<void> report() async {
    final data = {
      "reason": reson,
      "message": message.text.trim(),
      "email": email.text.trim(),
      "thread": Get.parameters["id"],
    };
    try {
      Loader.instance.showCircularProgressIndicatorWithText();
      const url = "$baseUrl/chat/report/";
      final token = Authenticator.instance.fetchToken();
      await dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      await Fluttertoast.showToast(msg: "Report sent");
      Get.back();
      Get.back();
    } on DioError catch (e) {
      Get.back();
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Form(
          key: form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text(
                "Is there something wrong with this ad?",
                style: headline3,
              ),
              const SizedBox(height: 15),
              Text(
                "We're constantly working hard to assure that our ads meet high standards and we are very grateful for any kind of feedback from our users.",
                style: text2.copyWith(color: kWhiteColor4),
              ),
              const SizedBox(height: 15),
              Text(
                "Reson",
                style: text2.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              GestureDetector(
                onTap: () {
                  showCupertinoModalPopup(
                    context: context,
                    builder: (context) => CupertinoActionSheet(
                      actions: [
                        CupertinoActionSheetAction(
                          onPressed: () {
                            setState(() {
                              reson = "Scam";
                            });
                            Get.back();
                          },
                          child: Text(
                            "Scam",
                            style: headline3.copyWith(color: kPrimaryColor),
                          ),
                        ),
                        CupertinoActionSheetAction(
                          onPressed: () {
                            setState(() {
                              reson = "Bot or Fake account";
                            });
                            Get.back();
                          },
                          child: Text(
                            "Bot or Fake account",
                            style: headline3.copyWith(color: kPrimaryColor),
                          ),
                        ),
                        CupertinoActionSheetAction(
                          onPressed: () {
                            setState(() {
                              reson = "Profanity";
                            });
                            Get.back();
                          },
                          child: Text(
                            "Profanity",
                            style: headline3.copyWith(color: kPrimaryColor),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kWhiteColor3),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        reson,
                        style: text1.copyWith(color: kWhiteColor6),
                      ),
                      const Icon(
                        Icons.keyboard_arrow_down_rounded,
                        color: kWhiteColor8,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                "Email",
                style: text2.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              CustomTextInput(
                controller: email,
                hintText: "example@offerup.com",
                validator: (value) {
                  if (value == null || value.isEmpty) return "Field required";
                  if (!value.isEmail) return "Email not valid";
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Text(
                "Message",
                style: text2.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              CustomTextInput(
                controller: message,
                lines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Field required";
                  return null;
                },
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (form.currentState!.validate() && reson != "Select") {
                        report();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 10),
                      textStyle: headline3.copyWith(fontWeight: FontWeight.bold),
                    ),
                    child: const Text("Send"),
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

class ResonSheet extends StatelessWidget {
  const ResonSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
