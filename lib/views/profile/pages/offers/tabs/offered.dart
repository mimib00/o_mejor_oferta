import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/models/offer.dart';
import 'package:mejor_oferta/meta/widgets/loading.dart';
import 'package:mejor_oferta/views/offer/components/offer_tile.dart';
import 'package:mejor_oferta/views/profile/controller/offers_controller.dart';

class OfferedTab extends GetView<OfferController> {
  const OfferedTab({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Offer>>(
      future: controller.getOffered(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Loading());
        if (snapshot.data == null || snapshot.data!.isEmpty) return Container();
        final offers = snapshot.data!;
        return ListView.builder(
          itemCount: offers.length,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return OfferTile(
              id: offers[index].id,
              listing: offers[index].listing,
            );
          },
        );
      },
    );
  }
}
