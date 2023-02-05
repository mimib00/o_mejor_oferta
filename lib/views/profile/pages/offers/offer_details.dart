import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/models/offer.dart';
import 'package:mejor_oferta/meta/widgets/loading.dart';
import 'package:mejor_oferta/views/offer/components/offer_tile.dart';
import 'package:mejor_oferta/views/profile/controller/offers_controller.dart';

class OfferDetails extends GetView<OfferController> {
  final int id;
  const OfferDetails({
    super.key,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("offers_title".tr),
      ),
      body: FutureBuilder<List<Offer>>(
        future: controller.getOffers(id),
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
      ),
    );
  }
}
