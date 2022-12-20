import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/listing.dart';

class OffersController extends GetxController {
  final TextEditingController price = TextEditingController();
  final dio = Dio();

  Listing listing = Get.arguments;

  Future<void> createChatRoom() async {
    try {
      final url = "$baseUrl/chat/get-thread/${listing.owner.email}/";
      final token = Authenticator.instance.fetchToken();
      await dio.get(
        url,
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

  Future<void> makeOffer() async {
    try {
      final url = "$baseUrl/offers/${listing.id}/offers/";
      final token = Authenticator.instance.fetchToken();

      final data = {
        "listing": listing.id,
        "price": price.text.trim(),
      };
      await dio.post(
        url,
        data: data,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      await createChatRoom();
      Get.back();
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
}
