import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/state.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/add_post/controller/add_post_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LocationSheet extends GetView<AddPostController> {
  final Function(States state)? onTap;
  const LocationSheet({
    super.key,
    this.onTap,
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
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Locations",
            style: headline2.copyWith(fontWeight: FontWeight.bold),
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
                return Expanded(
                  child: ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: locations.length,
                    itemBuilder: (context, index) {
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
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }
}
