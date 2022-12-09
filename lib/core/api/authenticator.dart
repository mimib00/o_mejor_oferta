import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/models/user.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';

class Authenticator {
  /// Handels all user actions
  ///
  /// from login to register to getting user info.
  Authenticator._init();

  static final Authenticator instance = Authenticator._init();

  final dio = Dio();

  final _box = GetStorage('Auth');

  void _saveToken(Map<String, dynamic> tokens) async => await _box.write("tokens", tokens);

  Map<String, dynamic> fetchToken() {
    return _box.read<Map<String, dynamic>>("tokens") ?? {};
  }

  Future<void> _removeToken() async => await _box.remove("tokens");

  /// Changes auth state of user in realtime.
  Stream<bool> onAuthStateChange() {
    StreamController<bool> controller = StreamController<bool>();
    if (_box.read("tokens") != null) {
      controller.add(true);
    } else {
      controller.add(false);
    }

    _box.listenKey("tokens", (token) {
      if (token == null) {
        controller.add(false);
      } else {
        controller.add(true);
      }
    });

    return controller.stream;
  }

  Future<void> login(Map<String, dynamic> data) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator(color: kPrimaryColor)));
      const url = "$baseUrl/token/";
      final res = await dio.post(
        url,
        data: data,
      );

      _saveToken(res.data);
      Get.back();
    } on DioError catch (e) {
      Get.back();
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    }
  }

  Future<void> signup(Map<String, dynamic> data) async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator(color: kPrimaryColor)));
      const url = "$baseUrl/authentication/users/";
      await dio.post(
        url,
        data: data,
      );
      Get.offAllNamed(Routes.login);
    } on DioError catch (e) {
      Get.back();
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    }
  }

  Future<User?> getUser() async {
    try {
      const url = "$baseUrl/authentication/users/me";
      final tokens = fetchToken();
      final res = await dio.get(
        url,
        options: Options(headers: {
          "Authorization": "Bearer ${tokens["access"]}",
        }),
      );

      return User.fromJson(res.data);
    } on DioError catch (e) {
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
      return null;
    }
  }

  Future<void> logout() async {
    await _removeToken();
  }
}
