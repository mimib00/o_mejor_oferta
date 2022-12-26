import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/listing.dart';

class SellingController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;

  final dio = Dio();

  RxList<Listing> selling = <Listing>[].obs;
  RxList<Listing> sold = <Listing>[].obs;
  RxList<Listing> archive = <Listing>[].obs;

  Future<void> getActiveListings() async {
    try {
      const url = "$baseUrl/listings/listings/my-active-listings/";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );

      List<Listing> listings = [];
      for (var item in res.data) {
        listings.add(Listing.fromJson(item));
      }

      selling.value = listings;
      update();
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

  Future<void> getSoldListings() async {
    try {
      const url = "$baseUrl/listings/listings/my-sold-listings/";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );

      List<Listing> listings = [];
      for (var item in res.data) {
        listings.add(Listing.fromJson(item));
      }

      sold.value = listings;
      update();
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

  Future<void> getArchivedListings() async {
    try {
      const url = "$baseUrl/listings/listings/my-archived-listings/";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );

      List<Listing> listings = [];
      for (var item in res.data) {
        listings.add(Listing.fromJson(item));
      }

      archive.value = listings;
      update();
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

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }
}
