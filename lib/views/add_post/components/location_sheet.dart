import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/add_post/controller/add_post_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LocationSheet extends GetView<AddPostController> {
  LocationSheet({super.key});

  final List<String> locations = [
    "Loiza",
    "Canovanas",
    "Carolina",
    "Trujillo Alto",
    "San Juan",
    "Guaynabo",
    "Bayamon",
    "Catano",
    "Toa Baja"
  ];

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
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: locations.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    controller.location.value = locations[index];
                    Get.back();
                  },
                  title: Text(locations[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
