import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/dashboard/controller/dashboard_controller.dart';
import 'package:mejor_oferta/views/profile/pages/offers/offer_details.dart';
import 'package:mejor_oferta/views/selling/controller/selling_controller.dart';

class ListingVertTile extends StatelessWidget {
  final Listing listing;
  const ListingVertTile({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = Container();

    if (listing.status == ListingStatus.published) {
      child = Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          GestureDetector(
            onTap: () => Get.toNamed(Routes.boost, arguments: listing),
            child: Text(
              "boost_btn".tr,
              style: text2.copyWith(color: kPrimaryColor),
            ),
          ),
          const SizedBox(width: 20),
          GestureDetector(
            onTap: () async {
              final DashboardController controller = Get.put(DashboardController());
              final SellingController sellingController = Get.put(SellingController());
              await controller.markSold(list: listing.id);
              sellingController.getActiveListings();
            },
            child: Text(
              "mark_sold_btn".tr,
              style: text2.copyWith(color: kPrimaryColor),
            ),
          ),
        ],
      );
    } else {
      child = Text(
        listing.status.name,
        style: headline3.copyWith(color: kPrimaryColor),
      );
    }
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.dashboard, arguments: listing),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: listing.images.first,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return Container(
                    alignment: Alignment.center,
                    color: kPrimaryColor,
                    child: const Icon(Icons.error),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    listing.title,
                    style: text1,
                  ),
                  child,
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ListingThumbVertTile extends StatelessWidget {
  final ListingThumb listing;
  const ListingThumbVertTile({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(OfferDetails(id: listing.id)),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: listing.image,
                height: 50,
                width: 50,
                fit: BoxFit.cover,
                errorWidget: (context, url, error) {
                  return Container(
                    alignment: Alignment.center,
                    color: kPrimaryColor,
                    child: const Icon(Icons.error),
                  );
                },
              ),
            ),
            const SizedBox(width: 10),
            Text(
              listing.title,
              style: text1,
            ),
          ],
        ),
      ),
    );
  }
}
