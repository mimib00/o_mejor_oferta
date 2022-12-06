import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';

class Authenticator extends GetxController {
  /// Handels all user actions
  ///
  /// from login to register to getting user info.
  Authenticator._init();

  static final Authenticator instance = Authenticator._init();

  final dio = Dio();

  final _box = GetStorage('Auth');

  _saveToken(String aToken, String rToken) {
    _box.write("refresh_token", rToken);
    _box.write("access_token", aToken);
  }

  Map<String, dynamic> fetchToken() {
    return {
      "refresh_token": _box.read<String>("refresh_token"),
      "access_token": _box.read<String>("access_token"),
    };
  }

  _removeToken() {
    _box.remove("refresh_token");
    _box.remove("access_token");
  }

  Future<void> signup(Map<String, dynamic> data) async {
    try {
      log(data.toString());
      Get.dialog(const Center(child: CircularProgressIndicator(color: kPrimaryColor)));
      const url = "$baseUrl/authentication/users/";
      await dio.post(url, data: data);
      Get.offAllNamed(Routes.login);
    } on DioError catch (e) {
      Get.back();
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    }
  }
}
