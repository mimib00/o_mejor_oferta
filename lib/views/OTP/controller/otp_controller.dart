import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/config.dart';

class OtpController extends GetxController {
  final String phone = Get.parameters["phone"] ?? "";
  final String name = Get.parameters["name"] ?? "";
  final String email = Get.parameters["email"] ?? "";
  final String password = Get.parameters["password"] ?? "";

  final bool signup = Get.parameters["signup"] == "true";

  RxBool valid = false.obs;

  final dio = Dio();

  String code = "";

  Future<void> verifyOtp() async {
    try {
      final url = signup
          ? "$baseUrl/authentication/users/signup-otp-verify/"
          : "$baseUrl/authentication/users/password-reset-otp-verify/";
      final res = await dio.post(
        url,
        data: {
          "code": code,
          "phone_number": phone,
        },
      );

      if (res.statusCode == 200) valid.value = true;
      update();
    } on DioError catch (e) {
      log(e.message);
      Fluttertoast.showToast(msg: e.message);
    }
  }

  Future<void> sendOtp() async {
    try {
      final url =
          signup ? "$baseUrl/authentication/users/signup-otp/" : "$baseUrl/authentication/users/password-reset-otp/";
      await dio.post(
        url,
        data: {
          "phone_number": phone,
        },
      );

      update();
    } on DioError catch (e) {
      log(e.message);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    }
  }

  @override
  void onInit() {
    sendOtp();
    super.onInit();
  }
}
