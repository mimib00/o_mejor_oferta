import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/models/chat.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:mejor_oferta/meta/models/offer.dart';
import 'package:mejor_oferta/meta/widgets/loader.dart';

class OffersController extends GetxController {
  final TextEditingController price = TextEditingController();
  final dio = Dio();

  Listing? listing = Get.arguments;

  Future<void> createChatRoom({Listing? listings}) async {
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
      final InboxThread thread = InboxThread.fromJson(res.data["chat_thread"]);
      Get.toNamed(
        Routes.inbox,
        parameters: {
          "id": res.data["chat_thread"]["id"].toString(),
          "name": (listings ?? listing!).owner.name,
          "uid": (listings ?? listing!).owner.id.toString(),
        },
        arguments: thread,
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
      Loader.instance.showCircularProgressIndicatorWithText();
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
      Get.back();
      debugPrintStack(stackTrace: stackTrace);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.response!.data["detail"]);
    } catch (e, stackTrace) {
      Get.back();
      log(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  Future<List<Offer>> getMyOffers() async {
    try {
      Loader.instance.showCircularProgressIndicatorWithText();
      final url = "$baseUrl/offers/${listing!.id}/offers/";
      final token = Authenticator.instance.fetchToken();

      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );

      List<Offer> offers = [];
      for (var offer in res.data) {
        offers.add(Offer.fromJson(offer, listing!));
      }
      Get.back();
      return offers;
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
    return [];
  }

  Future<void> acceptOffer(int id) async {
    try {
      Loader.instance.showCircularProgressIndicatorWithText();
      final url = "$baseUrl/offers/${listing!.id}/offers/$id/accept/";
      final token = Authenticator.instance.fetchToken();

      await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      Get.back();
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

  Future<void> rejectOffer(int id) async {
    try {
      Loader.instance.showCircularProgressIndicatorWithText();
      final url = "$baseUrl/offers/${listing!.id}/offers/$id/decline/";
      final token = Authenticator.instance.fetchToken();

      await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      Get.back();
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
}
