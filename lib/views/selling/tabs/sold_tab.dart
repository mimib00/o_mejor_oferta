import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/views/selling/components/listing_vert_tile.dart';
import 'package:mejor_oferta/views/selling/controller/selling_controller.dart';

class SoldTab extends GetView<SellingController> {
  const SoldTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: controller.getSoldListings(),
      builder: (context, snapshot) {
        if (controller.sold.isEmpty) return Container();
        return Obx(
          () {
            final listings = controller.sold;
            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: listings.length,
              itemExtent: 120,
              itemBuilder: (context, index) {
                return ListingVertTile(
                  listing: listings[index],
                );
              },
            );
          },
        );
      },
    );
  }
}
