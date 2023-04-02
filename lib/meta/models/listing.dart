import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/attributes.dart';
import 'package:mejor_oferta/meta/models/brand.dart';
import 'package:mejor_oferta/meta/models/category.dart';
import 'package:mejor_oferta/meta/models/state.dart';
import 'package:mejor_oferta/meta/models/user.dart';

import '../utils/constants.dart';

enum ListingStatus {
  draft,
  published,
  sold,
  archived;

  const ListingStatus();
  factory ListingStatus.getStatus(String status) {
    switch (status) {
      case "DRAFT":
        return ListingStatus.draft;
      case "PUBLISHED":
        return ListingStatus.published;
      case "SOLD":
        return ListingStatus.sold;
      case "ARCHIVED":
        return ListingStatus.archived;
      default:
        return ListingStatus.draft;
    }
  }
}

class ListingThumb {
  final int id;
  final String title;
  final States state;
  final double price;
  final String image;
  final DateTime created;
  final DateTime updated;
  final bool boosted;

  ListingThumb(
    this.id,
    this.title,
    this.state,
    this.price,
    this.image,
    this.created,
    this.updated,
    this.boosted,
  );

  factory ListingThumb.fromJson(Map<String, dynamic> data) {
    return ListingThumb(
      data["id"],
      data["name"],
      States.fromJson(data["state"]),
      double.parse(data["price"]),
      data["image"],
      DateTime.parse(data["created_at"]),
      DateTime.parse(data["updated_at"]),
      data["is_promoted"],
    );
  }
}

class Listing {
  final int id;
  final String title;
  final String description;
  final Category subCategory;
  final Brand? brand;
  final ListingStatus status;
  final States state;
  final double lat;
  final double long;
  final double price;
  final bool isNegotiable;
  final String? condition;
  final DateTime created;
  final DateTime updated;
  final User owner;
  final List<AttributeThumb> attributes;
  final List<String> images;
  final bool isFavorite;

  Listing(
    this.id,
    this.title,
    this.description,
    this.subCategory,
    this.brand,
    this.status,
    this.state,
    this.lat,
    this.long,
    this.price,
    this.isNegotiable,
    this.condition,
    this.created,
    this.updated,
    this.owner,
    this.attributes,
    this.images,
    this.isFavorite,
  );

  factory Listing.fromJson(Map<String, dynamic> data) {
    final List<AttributeThumb> attribs = [];
    for (var attribute in data["attributes"]) {
      if (attribute["title"] == "Title" || attribute["title"] == "Description" || attribute["title"] == "Price") {
        continue;
      }
      attribs.add(AttributeThumb.fromJson(attribute));
    }
    return Listing(
      data["id"],
      data["name"],
      data["description"],
      Category.fromJson(data["sub_category"]),
      data["product_model"] == null ? null : Brand.fromJson(data["product_model"]),
      ListingStatus.getStatus(data["status"]),
      States.fromJson(data["state"]),
      double.parse(data["location_lat"]),
      double.parse(data["location_long"]),
      double.parse(data["price"]),
      data["is_negotiable"] ?? false,
      data["get_condition_display"],
      DateTime.parse(data["created_at"]),
      DateTime.parse(data["updated_at"]),
      User.fromJson(data["user"]),
      attribs,
      data["images"].cast<String>(),
      data["is_favorite"],
    );
  }

  Future<void> delete() async {
    try {
      Get.dialog(const Center(child: CircularProgressIndicator(color: kPrimaryColor)));
      final dio = Dio();
      final url = "$baseUrl/listings/listings/$id/";
      final tokens = Authenticator.instance.fetchToken();
      await dio.delete(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${tokens["access"]}",
          },
        ),
      );
      Get.back();
      Get.back();
    } on DioError catch (e) {
      Get.back();
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    }
  }
}
