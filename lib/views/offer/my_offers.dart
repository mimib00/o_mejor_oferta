import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/models/offer.dart';
import 'package:mejor_oferta/meta/widgets/loading.dart';
import 'package:mejor_oferta/views/offer/components/offer_tile.dart';
import 'package:mejor_oferta/views/offer/controller/offers_controller.dart';

class SeeOffers extends GetView<OffersController> {
  const SeeOffers({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Offers"),
      ),
      body: FutureBuilder<List<Offer>>(
        future: controller.getMyOffers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Loading());

          if (snapshot.data == null || snapshot.data!.isEmpty) return Container();
          final offers = snapshot.data!;
          return ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: offers.length,
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
            itemBuilder: (context, index) {
              return OfferTile(
                id: offers[index].id,
                listing: offers[index].listing,
              );
            },
          );
        },
      ),
    );
  }
}
