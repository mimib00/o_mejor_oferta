import 'dart:developer';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:latlng/latlng.dart';
import 'package:map/map.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/listing.dart';

class PostController extends GetxController {
  late MapController controller;
  final CarouselController carouselController = CarouselController();
  final dio = Dio();

  RxInt index = 0.obs;

  Rx<Listing?> listing = Rx(null);

  get markers => [LatLng(listing.value!.lat, listing.value!.long)];

  Future<void> getListing() async {
    try {
      final id = Get.parameters["id"];
      final url = "$baseUrl/listings/listings/$id";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      listing.value = Listing.fromJson(res.data);
      update();
    } on DioError catch (e, stackTrace) {
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
  void onInit() async {
    await getListing();
    controller = MapController(location: LatLng(listing.value?.lat ?? 0, listing.value?.long ?? 0), zoom: 13);
    super.onInit();
  }
}
