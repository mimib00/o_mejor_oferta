// ignore_for_file: prefer_final_fields

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart' as gety;
import 'package:image_picker/image_picker.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/core/controller/location_controller.dart';
import 'package:mejor_oferta/meta/models/attributes.dart';
import 'package:mejor_oferta/meta/models/brand.dart';
import 'package:mejor_oferta/meta/models/category.dart';
import 'package:mejor_oferta/meta/models/state.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/utils/helper.dart';
import 'package:mejor_oferta/views/add_post/steps/category.dart';
import 'package:mejor_oferta/views/add_post/steps/info.dart';
import 'package:mejor_oferta/views/add_post/steps/info_steps/attributes.dart';
import 'package:mejor_oferta/views/add_post/steps/info_steps/brands.dart';
import 'package:mejor_oferta/views/add_post/steps/location.dart';
import 'package:mejor_oferta/views/add_post/steps/sub_category.dart';
import 'package:mejor_oferta/views/home/controller/home_controller.dart';
import 'package:uuid/uuid.dart';

class AddPostController extends gety.GetxController {
  final dio = Dio();

  final LocationController controller = gety.Get.find();
  final HomeController homeController = gety.Get.find();

  gety.RxInt stepIndex = 0.obs;
  gety.RxInt infoStepIndex = 1.obs;

  Widget get step => steps[stepIndex.value];
  Widget get infoStep => infoSteps[infoStepIndex.value - 1];
  double get percentage => infoStepIndex.value / infoSteps.length;

  Category? category;
  Category? subCategory;

  Brand? brand;
  Brand? product;

  String title = "";
  String description = "";
  String price = "";

  gety.Rx<States?> location = gety.Rx(null);
  gety.RxString condition = "".obs;
  gety.RxSet<Map<String, dynamic>> attributes = <Map<String, dynamic>>{}.obs;
  gety.RxBool negotiable = false.obs;
  gety.RxList<XFile> images = <XFile>[].obs;

  List<Widget> steps = [
    const CategoryStep(),
    const SubCategoryStep(),
    const LocationStep(),
    const InfoStep(),
  ];

  List<Widget> infoSteps = [];

  void next() {
    if (stepIndex.value == steps.length) return;
    stepIndex.value += 1;
    update();
  }

  void nextInfo() {
    if (infoStepIndex.value == infoSteps.length) return;
    infoStepIndex.value += 1;
    update();
  }

  void back() {
    if (stepIndex.value == 0) return;
    stepIndex.value -= 1;
    update();
  }

  void backInfo() {
    if (infoStepIndex.value == 0) return;
    infoStepIndex.value -= 1;
    update();
  }

  Future<void> getBrands() async {
    try {
      final url = "$baseUrl/listings/subcategories/${subCategory!.id}/brands";
      final res = await dio.get(url);

      List<Brand> brands = [];
      for (final brand in res.data) {
        brands.add(Brand.fromJson(brand));
      }

      if (brands.isNotEmpty) infoSteps.add(BrandsStep(brands: brands));
    } on DioError catch (e) {
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
      return;
    }
  }

  Future<void> getProducts() async {
    try {
      final url = "$baseUrl/listings/brands/${brand!.id}/product-models";
      final res = await dio.get(url);

      List<Brand> brands = [];
      for (final brand in res.data) {
        brands.add(Brand.fromJson(brand));
      }
      log(infoSteps.length.toString());
      infoSteps.insert(1, BrandsStep(brands: brands, isBrands: false));
      log(infoSteps.length.toString());
      update();
    } on DioError catch (e) {
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
      return;
    }
  }

  Future<void> getAttributes() async {
    try {
      final url = "$baseUrl/listings/categories/${subCategory!.id}/possible-attributes";
      final res = await dio.get(url);

      for (final attribute in res.data) {
        infoSteps.add(AttributesStep(attribute: Attributes.fromJson(attribute)));
      }
      final data = [
        {
          "id": -1,
          "title": "Title",
          "sub_title": "Please add a short title here",
          "sequence": 2147483647,
          "is_required": true,
          "input_type": "TEXT",
          "choices": [],
          "sub_category": -1,
        },
        {
          "id": -1,
          "title": "Description",
          "sub_title": "Describe the main features of your item.",
          "sequence": 2147483647,
          "is_required": true,
          "input_type": "TEXTAREA",
          "choices": [],
          "sub_category": -1,
        },
        {
          "id": -1,
          "title": "Price",
          "sub_title": "How much do you want to sell your item for?",
          "sequence": 2147483647,
          "is_required": true,
          "input_type": "NUMBER",
          "choices": [],
          "sub_category": -1,
        },
        {
          "id": -1,
          "title": "Add photos",
          "sub_title": "Upload pictures of your item.",
          "sequence": 2147483647,
          "is_required": true,
          "input_type": "IMAGES",
          "choices": [],
          "sub_category": -1,
        },
      ];

      for (var item in data) {
        infoSteps.add(AttributesStep(attribute: Attributes.fromJson(item)));
      }
    } on DioError catch (e) {
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
      return;
    }
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
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
      return [];
    }
  }

  Future<void> postListing() async {
    try {
      final storage = FirebaseStorage.instance.ref();
      const uuid = Uuid();
      const url = "$baseUrl/listings/listings/";
      final token = Authenticator.instance.fetchToken();
      gety.Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            color: kPrimaryColor,
          ),
        ),
        barrierDismissible: false,
      );
      attributes.removeWhere((element) => element["possible_attribute"] == -1);
      final data = {
        "name": title,
        "description": description,
        "product_model": product?.id,
        "state": location.value!.id,
        "location_lat": (controller.locationData?.latitude ?? 0).toString(),
        "location_long": (controller.locationData?.longitude ?? 0).toString(),
        "price": price,
        "is_negotiable": negotiable.value,
        "sub_category": subCategory!.id,
        "condition": condition.value.replaceAll("-", "").replaceAll("  ", " ").replaceAll(" ", "_").toUpperCase(),
        "attributes": attributes.toList(),
      };
      List<String> photos = [];
      final id = uuid.v4();
      for (final image in images) {
        final bucket = storage.child("listings/$id/${image.name}");
        try {
          final snapshot = await bucket.putFile(
            File(image.path),
            SettableMetadata(
              contentType: "image/jpeg",
            ),
          );
          if (snapshot.state == TaskState.error || snapshot.state == TaskState.canceled) {
            throw "There was an error during upload";
          }
          if (snapshot.state == TaskState.success) {
            var offensiveImage = await validateImage(bucket.fullPath, bucket.bucket);
            if (offensiveImage) {
              Fluttertoast.showToast(msg: "Offensive Image detected");
              gety.Get.back();
              return;
            }
            var imageUrl = await snapshot.ref.getDownloadURL();
            photos.add(imageUrl);
          }
        } on FirebaseException catch (e) {
          log(e.code);
        }
      }

      await dio.post(
        url,
        data: {
          ...data,
          "images": photos,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      homeController.stop = false;
      homeController.page = 0;
      homeController.pagingController.refresh();
      gety.Get.back();
      gety.Get.back();
    } on DioError catch (e) {
      gety.Get.back();
      log(e.message);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e, stackTrace) {
      gety.Get.back();
      log(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  @override
  void onClose() {
    stepIndex.value = 0;
    category = null;
    subCategory = null;
    super.onClose();
  }
}
