// ignore_for_file: prefer_final_fields

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/category.dart';
import 'package:mejor_oferta/views/add_post/steps/category.dart';
import 'package:mejor_oferta/views/add_post/steps/location.dart';
import 'package:mejor_oferta/views/add_post/steps/sub_category.dart';

class AddPostController extends GetxController {
  final dio = Dio();

  RxInt _step = 0.obs;

  Widget get step => steps[_step.value];

  Category? category;
  Category? subCategory;

  RxString location = "Location".obs;

  List<Widget> steps = [
    const CategoryStep(),
    const SubCategoryStep(),
    const LocationStep(),
  ];

  void next() {
    if (_step.value == steps.length) return;
    _step.value += 1;
    update();
  }

  Future<List<Category>> getCategories() async {
    try {
      const url = "$baseUrl/listings/categories";
      final res = await dio.get(url);

      List<Category> categories = [];
      for (var category in res.data) {
        categories.add(Category.fromJson(category));
      }
      return categories;
    } on DioError catch (e) {
      Get.back();
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
      return [];
    }
  }

  Future<List<Category>> getSubCategories() async {
    try {
      final url = "$baseUrl/listings/categories/${category?.id}/subcategories/";
      final res = await dio.get(url);

      List<Category> categories = [];
      for (var category in res.data) {
        categories.add(Category.fromJson(category));
      }
      return categories;
    } on DioError catch (e) {
      Get.back();
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
      return [];
    }
  }

  @override
  void onClose() {
    _step.value = 0;
    category = null;
    subCategory = null;
    super.onClose();
  }
}
