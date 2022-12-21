import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/loading.dart';
import 'package:mejor_oferta/views/profile/components/saved_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SavedPosts extends StatelessWidget {
  const SavedPosts({super.key});

  Future<List<ListingThumb>> getSavedItems() async {
    try {
      final dio = Dio();

      const url = "$baseUrl/listings/listings/favorite-listings/";
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor5,
      appBar: AppBar(
        title: const Text("Saved Items"),
      ),
      body: FutureBuilder<List<ListingThumb>>(
        future: getSavedItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Loading());
          if (snapshot.data == null || snapshot.data!.isEmpty) return Container();
          final items = snapshot.data!;
          return ListView.builder(
            itemCount: items.length,
            padding: const EdgeInsets.only(top: 20),
            physics: const BouncingScrollPhysics(),
            itemExtent: 15.h,
            itemBuilder: (context, index) {
              return SavedItemTile(listing: items[index]);
            },
          );
        },
      ),
    );
  }
}
