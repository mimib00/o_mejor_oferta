import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/user.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/loader.dart';
import 'package:mejor_oferta/meta/widgets/loading.dart';
import 'package:mejor_oferta/views/home/components/listing_tile.dart';
import 'package:mejor_oferta/views/profile/components/profile_info.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class SellerProfile extends StatelessWidget {
  final int id;
  SellerProfile({
    super.key,
    required this.id,
  });

  final dio = Dio();

  Future<User?> getUser() async {
    try {
      final url = "$baseUrl/authentication/users/$id/user-profile-with-listings/";
      final res = await dio.get(url);
      return User.fromJson(res.data);
    } on DioError catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e, stackTrace) {
      log(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      Fluttertoast.showToast(msg: e.toString());
    }
    return null;
  }

  Future<void> rateUser(double rating) async {
    try {
      Loader.instance.showCircularProgressIndicatorWithText();
      const url = "$baseUrl/authentication/create-rating/";
      final token = Authenticator.instance.fetchToken();

      await dio.post(
        url,
        data: {"rating": rating, "rating_for": id},
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      Get.back();
      Get.back();
    } on DioError catch (e, stackTrace) {
      Get.back();
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<User?>(
        future: getUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Loading());
          if (snapshot.data == null) return Container();
          final user = snapshot.data!;
          final me = Authenticator.instance.user.value;
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    ProfileInfoTile(
                      user: user,
                      showStatus: false,
                    ),
                    const Spacer(),
                    Visibility(
                      visible: me?.id != user.id,
                      child: FloatingActionButton(
                        onPressed: () {
                          double rate = 0;
                          Get.defaultDialog(
                            title: "Rating",
                            content: Column(
                              children: [
                                const Text("How many stars you wanna give this user?"),
                                const SizedBox(height: 15),
                                RatingBar(
                                  ratingWidget: RatingWidget(
                                    empty: const Icon(
                                      Icons.star_rounded,
                                      color: kWhiteColor4,
                                    ),
                                    half: const Icon(
                                      Icons.star_half_rounded,
                                      color: Colors.amber,
                                    ),
                                    full: const Icon(
                                      Icons.star_rounded,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  onRatingUpdate: (value) {
                                    rate = value;
                                  },
                                ),
                              ],
                            ),
                            confirm: ElevatedButton(
                              onPressed: () async => rateUser(rate),
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10),
                                textStyle: headline3.copyWith(fontWeight: FontWeight.bold),
                              ),
                              child: const Text("Rate"),
                            ),
                          );
                        },
                        elevation: 0,
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white,
                        child: const Icon(UniconsLine.edit),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: () => launchUrl(Uri.parse("tel:${user.phone}")),
                      elevation: 0,
                      backgroundColor: kPrimaryColor,
                      foregroundColor: Colors.white,
                      child: const Icon(UniconsLine.phone),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Listings",
                  style: headline2,
                ),
                const SizedBox(height: 10),
                GridView.builder(
                  itemCount: user.listings.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: .7,
                  ),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return ListingTile(listing: user.listings[index]);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
