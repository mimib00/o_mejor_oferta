import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/core/controller/location_controller.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/models/user.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/loader.dart';

class Authenticator extends GetxController {
  /// Handels all user actions
  ///
  /// from login to register to getting user info.
  Authenticator._init();

  static final Authenticator instance = Authenticator._init();

  final dio = Dio();

  final _box = GetStorage('Auth');

  Rx<User?> user = Rx(null);

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
        options: Options(
          headers: {
            "Authorization": "Bearer ${tokens["access"]}",
          },
        ),
      );
      user.value = User.fromJson(res.data);
      update();
      return user.value;
    } on DioError catch (e) {
      await logout();
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
      return null;
    }
  }

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

  Future<void> setFCMToken() async {
    try {
      final fcm = await FirebaseMessaging.instance.getToken();
      if (_box.read("FCM") == fcm) return;

      const url = "$baseUrl/notifications/add-fcm-notification-device/";
      final token = fetchToken();

      await _box.write("FCM", fcm);

      await dio.post(
        url,
        data: {
          "name": user.value?.name,
          "registration_id": fcm,
          "type": Platform.operatingSystem,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
    } on DioError catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e, stackTrace) {
      log(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<void> updateLocation() async {
    try {
      final LocationController controller = Get.find();
      const url = "$baseUrl/authentication/users/me/";
      final token = Authenticator.instance.fetchToken();
      await dio.patch(
        url,
        data: {
          "location_lat": controller.locationData.latitude.toString(),
          "loaction_long": controller.locationData.longitude.toString(),
        },
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
    } on DioError catch (e) {
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    }
  }

  Future<void> deleteUser() async {
    try {
      const url = "$baseUrl/authentication/users/me/";
      final tokens = fetchToken();
      await dio.delete(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${tokens["access"]}",
          },
        ),
      );
      await logout();
    } on DioError catch (e) {
      log(e.message);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    }
  }

  Future<void> logout() async {
    await _removeToken();
  }
}
