import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:mejor_oferta/meta/models/stats.dart';
import 'package:mejor_oferta/meta/widgets/loader.dart';

class DashboardController extends GetxController {
  final dio = Dio();

  Listing listing = Get.arguments;

  int total = 0;

  Future<void> markSold() async {
    try {
      Loader.instance.showCircularProgressIndicatorWithText();
      final url = "$baseUrl/listings/listings/${listing.id}/mark_sold/";
      final token = Authenticator.instance.fetchToken();
      await dio.post(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      Get.back();
    } on DioError catch (e) {
      Get.back();
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    }
  }

  Future<List<Stats>> getStats() async {
    try {
      final url = "$baseUrl/listings/listings/${listing.id}/get-monthly-stats-per-day/";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      total = res.data["total_views"];
      List<Stats> stats = [];
      for (var stat in res.data["stats"]) {
        stats.add(Stats(stat["count"], stat["formatted_date"]));
      }
      return stats;
    } on DioError catch (e) {
      Get.back();
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    }
    return [];
  }
}
