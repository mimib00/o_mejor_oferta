import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/text_input.dart';
import 'package:mejor_oferta/views/offer/controller/offers_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OfferScreen extends GetView<OffersController> {
  const OfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(top: 30, left: 10, right: 10),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: controller.listing!.images.isNotEmpty ? controller.listing!.images.first : "",
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) {
                      return Container(
                        alignment: Alignment.center,
                        color: kPrimaryColor,
                        height: 100,
                        width: 100,
                        child: const Icon(Icons.error),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 15),
                Text(
                  controller.listing!.title.capitalize!,
                  style: headline2.copyWith(fontWeight: FontWeight.w600),
                )
              ],
            ),
            const SizedBox(height: 30),
            Text(
              "enter_offer".tr,
              style: headline2.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: CustomTextInput(
                controller: controller.price,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) return "Must enter a price";
                  return null;
                },
                hintText: "\$0",
              ),
            ),
            const SizedBox(height: 60),
            ElevatedButton(
              onPressed: () => controller.makeOffer(),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10),
                textStyle: headline3.copyWith(fontWeight: FontWeight.bold),
              ),
              child: Text("send_offer_btn".tr),
            ),
          ],
        ),
      ),
    );
  }
}
