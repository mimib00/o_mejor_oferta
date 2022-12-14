import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/listing.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;

  final dio = Dio();

  Future<List<ListingThumb>> getListings() async {
    try {
      const url = "$baseUrl/listings/listings/";
      final res = await dio.get(url);

      List<ListingThumb> thumbs = [];
      for (final thumb in res.data) {
        thumbs.add(ListingThumb.fromJson(thumb));
      }

      return thumbs;
    } on DioError catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
      return [];
    }
  }

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    super.onInit();
  }
}
