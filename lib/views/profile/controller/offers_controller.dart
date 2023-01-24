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

  Future<List<ListingThumb>> getMyOfferdListings() async {
    try {
      const url = "$baseUrl/listings/listings/listings-on-which-i-offered/";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        queryParameters: {"ordering": "-price"},
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      final List<ListingThumb> listings = [];
      for (var listing in res.data) {
        listings.add(ListingThumb.fromJson(listing));
      }
      return listings;
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

  Future<List<ListingThumb>> getMyAllListings() async {
    try {
      const url = "$baseUrl/listings/listings/my-listings/";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        queryParameters: {"ordering": "-created_at"},
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      final List<ListingThumb> listings = [];
      for (var listing in res.data) {
        listings.add(ListingThumb.fromJson(listing));
      }
      return listings;
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

  Future<List<Offer>> getOffers(int id) async {
    try {
      final url = "$baseUrl/offers/$id/offers/";
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
        final listing = await getListing(id);
        offers.add(Offer.fromJson(offer, listing!));
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
