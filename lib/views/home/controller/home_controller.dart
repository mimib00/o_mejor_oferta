import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/category.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomeController extends GetxController with GetTickerProviderStateMixin {
  late TabController tabController;

  final PagingController<int, ListingThumb> pagingController = PagingController(firstPageKey: 1);
  final RefreshController refreshController = RefreshController(initialRefresh: false);

  final dio = Dio();
  final limit = 4;

  int page = 1;

  bool stop = false;

  int? state;
  int? category;

  RxString query = "".obs;

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
          "state": state,
          "sub_category": category,
          "search": query.value,
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

      page += 1;
      final isLastPage = thumbs.length < limit;

      if (isLastPage) {
        pagingController.appendLastPage(thumbs);
      } else {
        pagingController.appendPage(thumbs, page);
      }
      if (res.data["next"] == null) stop = true;
      refreshController.refreshCompleted();
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

  Future<List<FullCategory>> getCategories() async {
    try {
      const url = "$baseUrl/listings/categories-with-subcategories/";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      List<FullCategory> categories = [];
      for (var category in res.data) {
        categories.add(FullCategory.fromJson(category));
      }
      return categories;
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

  Future<List<ListingThumb>> getBoostedPosts() async {
    try {
      const url = "$baseUrl/listings/listings/promoted-listings/";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      List<ListingThumb> thumbs = [];
      for (final thumb in res.data) {
        thumbs.add(ListingThumb.fromJson(thumb));
      }
      return thumbs;
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

  @override
  void onInit() {
    tabController = TabController(length: 3, vsync: this);
    pagingController.addPageRequestListener((pageKey) => getListings());
    debounce(
      query,
      (callback) {
        page = 1;
        stop = false;
        pagingController.refresh();
      },
    );
    super.onInit();
  }
}
