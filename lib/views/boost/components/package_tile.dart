import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/models/packages.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/boost/controller/boost_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PackageTile extends GetView<BoostController> {
  final Packages package;
  final int id;
  const PackageTile({
    super.key,
    required this.package,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kPrimaryColor),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Text(
            package.description,
            style: text3.copyWith(color: kPrimaryColor),
          ),
          const SizedBox(height: 10),
          Text(
            package.name,
            style: headline3.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "\$${package.price}",
            style: headline2.copyWith(fontWeight: FontWeight.bold, color: kPrimaryColor),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => controller.subscribe(package.id, id),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(left: 8.w, right: 8.w),
                  textStyle: headline3.copyWith(fontWeight: FontWeight.bold),
                ),
                child: const Text("Subscribe"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
