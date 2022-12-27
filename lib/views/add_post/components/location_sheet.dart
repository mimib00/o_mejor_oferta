import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/core/controller/search_controller.dart';
import 'package:mejor_oferta/meta/models/state.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/add_post/controller/add_post_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:unicons/unicons.dart';

class LocationSheet extends GetView<AddPostController> {
  final Function(States state)? onTap;
  final Function()? onReset;
  const LocationSheet({
    super.key,
    this.onTap,
    this.onReset,
  });

  Future<List<States>> getStates() async {
    try {
      final dio = Dio();
      const url = "$baseUrl/listings/states";
      final res = await dio.get(url);

      List<States> states = [];

      for (var state in res.data) {
        states.add(States.fromJson(state));
      }
      return states;
    } on DioError catch (e) {
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.h,
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Locations",
                style: headline2.copyWith(fontWeight: FontWeight.bold),
              ),
              Visibility(
                visible: onReset != null,
                child: GestureDetector(
                  onTap: onReset,
                  child: Text(
                    "Reset",
                    style: text2.copyWith(fontWeight: FontWeight.bold, color: kPrimaryColor),
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder<List<States>>(
            future: getStates(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: kPrimaryColor),
                );
              }
              if (snapshot.data == null || snapshot.data!.isEmpty) return Container();

              final locations = snapshot.data!;

              final SearchController searchController = Get.put(SearchController());
              searchController.locs = locations;
              return Obx(
                () {
                  searchController.locatioQuery.value;
                  return Expanded(
                    child: ListView(
                      physics: const BouncingScrollPhysics(),
                      children: [
                        const SizedBox(height: 10),
                        TextFormField(
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              UniconsLine.search,
                              color: kPrimaryColor,
                            ),
                            hintText: "Search location",
                            isDense: true,
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                            fillColor: kPrimaryColor5,
                            filled: true,
                          ),
                          onChanged: (value) {
                            searchController.locatioQuery.value = value;
                          },
                        ),
                        ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          itemCount:
                              searchController.locations.isEmpty ? locations.length : searchController.locations.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            if (searchController.locations.isEmpty) {
                              return ListTile(
                                onTap: () {
                                  if (onTap != null) {
                                    onTap?.call(locations[index]);
                                    Get.back();
                                    return;
                                  }
                                  controller.location.value = locations[index];
                                  Get.back();
                                },
                                title: Text(locations[index].name),
                              );
                            } else {
                              return ListTile(
                                onTap: () {
                                  if (onTap != null) {
                                    onTap?.call(searchController.locations[index]);
                                    Get.back();
                                    return;
                                  }
                                  controller.location.value = searchController.locations[index];
                                  Get.back();
                                },
                                title: Text(searchController.locations[index].name),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
