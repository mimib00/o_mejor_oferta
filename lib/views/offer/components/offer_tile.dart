import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/models/offer.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/main_button.dart';
import 'package:mejor_oferta/views/offer/controller/offers_controller.dart';

class OfferTile extends GetView<OffersController> {
  final Offer offer;
  const OfferTile({
    super.key,
    required this.offer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: kWhiteColor1,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            "User Name",
            style: headline3,
          ),
          const SizedBox(height: 10),
          Text(
            "Sent you a offer",
            style: text1.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            "\$${offer.price}",
            style: headline1.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: MainButton(
                  onTap: () => controller.rejectOffer(offer.id),
                  text: "Reject offer",
                ),
              ),
              Expanded(
                child: MainButton(
                  onTap: () => controller.acceptOffer(offer.id),
                  text: "Accept offer",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
