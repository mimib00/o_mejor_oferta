import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/listing.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;

  final PagingController<int, ListingThumb> pagingController = PagingController(firstPageKey: 1);

  final dio = Dio();
  final limit = 1;

  int page = 1;

  bool stop = false;

  Future<void> getListings() async {
    try {
      if (stop) return;
      const url = "$baseUrl/listings/listings/";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        queryParameters: {
          "page": page,
          "size": limit,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );

      List<ListingThumb> thumbs = [];
      for (final thumb in res.data["results"]) {
        thumbs.add(ListingThumb.fromJson(thumb));
      }

      thumbs.sort((a, b) => a.updated.compareTo(b.updated));

      page += limit;
      final isLastPage = thumbs.length < limit;

      if (isLastPage) {
        pagingController.appendLastPage(thumbs);
      } else {
        pagingController.appendPage(thumbs, page);
      }
      if (res.data["next"] == null) stop = true;
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
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    pagingController.addPageRequestListener((pageKey) => getListings());
    super.onInit();
  }
}
