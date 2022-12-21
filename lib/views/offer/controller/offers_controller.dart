import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/models/listing.dart';

class OffersController extends GetxController {
  final TextEditingController price = TextEditingController();
  final dio = Dio();

  Listing? listing = Get.arguments;

  Future<void> createChatRoom({Listing? listings}) async {
    log((listings ?? listing!).owner.id.toString());
    try {
      final url = "$baseUrl/chat/get-thread/${(listings ?? listing!).owner.email}/";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      Get.back();
      Get.toNamed(
        Routes.inbox,
        parameters: {
          "id": res.data["chat_thread"]["id"].toString(),
          "name": (listings ?? listing!).owner.name,
          "uid": (listings ?? listing!).owner.id.toString()
        },
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
      final url = "$baseUrl/offers/${listing!.id}/offers/";
      final token = Authenticator.instance.fetchToken();

      final data = {
        "listing": listing!.id,
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
