import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/loading.dart';
import 'package:mejor_oferta/views/selling/components/listing_vert_tile.dart';

class BoughtItems extends StatelessWidget {
  const BoughtItems({super.key});

  Future<List<ListingThumb>> getMyPurchases() async {
    try {
      final dio = Dio();

      const url = "$baseUrl/listings/listings/bought-listings/";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      log(res.data.toString());
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor5,
      appBar: AppBar(
        title: Text("purchased_items_title".tr),
      ),
      body: FutureBuilder<List<ListingThumb>>(
        future: getMyPurchases(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Loading());
          if (snapshot.data == null || snapshot.data!.isEmpty) return Container();
          final listings = snapshot.data!;

          return ListView.builder(
            itemCount: listings.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return ListingThumbVertTile(listing: listings[index]);
            },
          );
        },
      ),
    );
  }
}
