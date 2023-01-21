import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/chat.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:mejor_oferta/meta/models/stats.dart';
import 'package:mejor_oferta/meta/widgets/loader.dart';

class DashboardController extends GetxController {
  final dio = Dio();

  Listing? listing = Get.arguments;

  int total = 0;

  Future<void> archive(int id) async {
    try {
      Loader.instance.showCircularProgressIndicatorWithText();
      final url = "$baseUrl/listings/listings/$id/archive/";
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

  Future<void> markSold({int? list}) async {
    try {
      Loader.instance.showCircularProgressIndicatorWithText();
      final url = "$baseUrl/listings/listings/${list ?? listing!.id}/mark_sold/";
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
      final url = "$baseUrl/listings/listings/${listing!.id}/get-monthly-stats-per-day/";
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

  Future<List<InboxThread>> getListingThreads(int id) async {
    try {
      final url = "$baseUrl/chat/get-threads-by-listing/$id/";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      List<InboxThread> threads = [];
      for (var thread in res.data) {
        threads.add(InboxThread.fromJson(thread));
      }
      return threads;
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
}
