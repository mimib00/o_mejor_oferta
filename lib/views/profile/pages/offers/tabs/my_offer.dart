import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:mejor_oferta/meta/models/offer.dart';
import 'package:mejor_oferta/meta/widgets/loading.dart';
import 'package:mejor_oferta/views/profile/controller/offers_controller.dart';
import 'package:mejor_oferta/views/selling/components/listing_vert_tile.dart';

class MyOfferTab extends GetView<OfferController> {
  const MyOfferTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ListingThumb>>(
      future: controller.getMyAllListings(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Loading());
        if (snapshot.data == null || snapshot.data!.isEmpty) return Container();
        final listings = snapshot.data!;

        return ListView.builder(
          itemCount: listings.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return ListingThumbVertTile(listing: listings[index]);
          },
        );
      },
    );
  }
}
