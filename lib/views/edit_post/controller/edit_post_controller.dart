// ignore_for_file: prefer_final_fields

import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/attributes.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/add_post/steps/info_steps/attributes.dart';
import 'package:mejor_oferta/views/home/controller/home_controller.dart';
import 'package:uuid/uuid.dart';

class EditPostController extends GetxController {
  final HomeController homeController = Get.find();
  final dio = Dio();

  RxInt infoStepy = 1.obs;
  Widget get infoStep => infoSteps[infoStepy.value - 1];

  String title = "";
  String description = "";
  String price = "";

  RxString condition = "".obs;
  RxSet<Map<String, dynamic>> attributes = <Map<String, dynamic>>{}.obs;
  RxBool negotiable = false.obs;
  RxList<XFile> images = <XFile>[].obs;

  RxList<Widget> infoSteps = <Widget>[].obs;

  void nextInfo() {
    if (infoStepy.value == infoSteps.length) return;
    infoStepy.value += 1;
    update();
  }

  Future<void> getAttributes(Listing listing) async {
    try {
      final url = "$baseUrl/listings/categories/${listing.subCategory.id}/possible-attributes";
      final res = await dio.get(url);

      for (final attribute in res.data) {
        infoSteps.add(
          AttributesStep(
            attribute: Attributes.fromJson(attribute),
            editing: true,
            listing: listing,
          ),
        );
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
        infoSteps.add(
          AttributesStep(
            attribute: Attributes.fromJson(item),
            editing: true,
            listing: listing,
          ),
        );
      }
    } on DioError catch (e) {
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
      return;
    }
  }

  Future<void> updateListing(Listing listing) async {
    try {
      final storage = FirebaseStorage.instance.ref();
      const uuid = Uuid();
      final url = "$baseUrl/listings/listings/${listing.id}/";
      final token = Authenticator.instance.fetchToken();
      Get.dialog(
        const Center(
          child: CircularProgressIndicator(
            color: kPrimaryColor,
          ),
        ),
        barrierDismissible: false,
      );
      attributes.removeWhere((element) => element["possible_attribute"] == -1);
      Map<String, dynamic> data = {
        "name": title.isEmpty ? listing.title : title,
        "description": description.isEmpty ? listing.description : description,
        "price": price.isEmpty ? listing.price : price,
        "is_negotiable": negotiable.value,
        "attributes": attributes.toList(),
      };

      List<String> photos = [];
      final id = uuid.v4();
      for (final image in images) {
        try {
          final snapshot = await storage.child("listings/$id/${image.name}").putFile(
                File(image.path),
                SettableMetadata(
                  contentType: "image/jpeg",
                ),
              );
          if (snapshot.state == TaskState.error || snapshot.state == TaskState.canceled) {
            throw "There was an error during upload";
          }
          if (snapshot.state == TaskState.success) {
            var imageUrl = await snapshot.ref.getDownloadURL();
            photos.add(imageUrl);
          }
        } on FirebaseException catch (e) {
          log(e.code);
        }
      }
      if (photos.isNotEmpty) {
        data.addAll({
          "images": photos,
        });
      }
      await dio.patch(
        url,
        data: data,
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
      Get.back();
      Get.back();
    } on DioError catch (e) {
      Get.back();
      log(e.message);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
      return;
    }
  }
}
