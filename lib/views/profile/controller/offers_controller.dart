import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:mejor_oferta/meta/models/offer.dart';
import 'package:mejor_oferta/meta/widgets/loader.dart';

class OfferController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;

  final TextEditingController price = TextEditingController();

  final dio = Dio();

  Future<Listing?> getListing(int id) async {
    try {
      final url = "$baseUrl/listings/listings/$id/";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );

      return Listing.fromJson(res.data);
    } on DioError catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e, stackTrace) {
      log(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      Fluttertoast.showToast(msg: e.toString());
    }
    return null;
  }

  Future<List<Offer>> getMyOffers() async {
    try {
      const url = "$baseUrl/offers/my-pending-offers/";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );

      final List<Offer> offers = [];
      for (var offer in res.data) {
        final listing = await getListing(offer["listing"]);
        if (listing == null) continue;
        offers.add(Offer.fromJson(offer, listing));
      }
      return offers;
    } on DioError catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e, stackTrace) {
      log(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      Fluttertoast.showToast(msg: e.toString());
    }
    return [];
  }

  Future<List<Offer>> getOffered() async {
    try {
      const url = "$baseUrl/offers/offers-i-got/";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );

      final List<Offer> offers = [];
      for (var offer in res.data) {
        final listing = await getListing(offer["listing"]);
        if (listing == null) continue;
        offers.add(Offer.fromJson(offer, listing));
      }
      return offers;
    } on DioError catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e, stackTrace) {
      log(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      Fluttertoast.showToast(msg: e.toString());
    }
    return [];
  }

  Future<void> updateOffer(int offer, int listing) async {
    try {
      if (price.text.trim().isEmpty) return;
      Loader.instance.showCircularProgressIndicatorWithText();
      final url = "$baseUrl/offers/$listing/offers/$offer/";
      final token = Authenticator.instance.fetchToken();
      await dio.patch(
        url,
        data: {"price": price.text.trim()},
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

  @override
  void onInit() {
    tabController = TabController(length: 2, vsync: this);
    super.onInit();
  }
}
