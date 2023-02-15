import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/controller/location_controller.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FilterSheet extends StatefulWidget {
  final void Function(
    String? priceLTE,
    String? priceGTE,
    String? order,
    String? distance,
    String? boost,
  )? onTap;
  final Function()? onReset;
  const FilterSheet({
    super.key,
    required this.onTap,
    required this.onReset,
  });

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  final choices = [
    "Price (ASC)",
    "Price (DESC)",
    "Newest on Top",
    "Oldest on Top",
    "Most Viewed",
    "Least Viewed",
  ];

  final keys = [
    "price",
    "-price",
    "-created_at",
    "created_at",
    "-views_count",
    "views_count",
  ];

  String? choice;
  String? lte;
  String? gte;

  double slider = 0;

  bool boosted = false;

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
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "filters_title".tr,
                  style: headline2.copyWith(fontWeight: FontWeight.bold),
                ),
                Visibility(
                  visible: widget.onReset != null,
                  child: GestureDetector(
                    onTap: widget.onReset,
                    child: Text(
                      "reset".tr,
                      style: text2.copyWith(fontWeight: FontWeight.bold, color: kPrimaryColor),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              "sort_by".tr,
              style: text2.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            DropdownButtonHideUnderline(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: kWhiteColor3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DropdownButton<String>(
                  value: choice,
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      choice = value;
                    });
                  },
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  isExpanded: true,
                  items: choices.map((e) {
                    final index = choices.indexOf(e);
                    return DropdownMenuItem(
                      value: keys[index],
                      child: Text(e),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 30),
            Text(
              "sort_boosted".tr,
              style: text2.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              value: boosted,
              checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              activeColor: kPrimaryColor,
              visualDensity: VisualDensity.compact,
              onChanged: (value) {
                if (value == null) return;
                setState(() {
                  boosted = value;
                });
              },
              title: const Text("Boosted only"),
            ),
            const SizedBox(height: 30),
            Text(
              "sort_price".tr,
              style: text2.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      gte = value;
                    },
                    decoration: InputDecoration(
                      hintText: "\$ min",
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: kWhiteColor3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: kWhiteColor3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fillColor: kWhiteColor,
                      filled: true,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Text("or_msg".tr.toUpperCase()),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      lte = value;
                    },
                    decoration: InputDecoration(
                      hintText: "\$ max",
                      isDense: true,
                      border: OutlineInputBorder(
                        borderSide: const BorderSide(color: kWhiteColor3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: kPrimaryColor),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: kWhiteColor3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      fillColor: kWhiteColor,
                      filled: true,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              "sort_distance".tr,
              style: text2.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Slider(
              value: slider,
              label: slider == 100 ? "Max" : "${slider.round()} km",
              divisions: 5,
              thumbColor: kPrimaryColor,
              activeColor: kPrimaryColor,
              inactiveColor: kPrimaryColor10,
              onChanged: (value) {
                setState(() {
                  slider = value;
                });
              },
              min: 0,
              max: 100,
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String radius = "";
                    if (slider > 0) {
                      final LocationController controller = Get.find();
                      radius =
                          "${controller.locationData?.latitude ?? 0}, ${controller.locationData?.longitude ?? 0}, $slider";
                    }

                    widget.onTap?.call(
                      lte,
                      gte,
                      choice,
                      radius,
                      boosted.toString().capitalize,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10),
                    textStyle: headline3.copyWith(fontWeight: FontWeight.bold),
                  ),
                  child: Text("filter_title".tr),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
