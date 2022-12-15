import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/widgets/loader.dart';

class AccountController extends GetxController {
  final dio = Dio();

  RxString location = "".obs;

  Future<void> updateUser(Map<String, dynamic> data) async {
    try {
      Loader.instance.showCircularProgressIndicatorWithText();
      const url = "$baseUrl/authentication/users/me/";
      final token = Authenticator.instance.fetchToken();
      await dio.patch(
        url,
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      await Authenticator.instance.getUser();
      Get.back();
    } on DioError catch (e) {
      Get.back();
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    }
  }
}
