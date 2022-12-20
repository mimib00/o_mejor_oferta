import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

class SavedItemTile extends StatelessWidget {
  final ListingThumb listing;
  const SavedItemTile({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.post, parameters: {"id": listing.id.toString()}),
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: CachedNetworkImage(
                  imageUrl: listing.image,
                  width: 15.h,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) {
                    return Container(
                      width: 15.h,
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
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      listing.title.capitalize!,
                      style: text1,
                    ),
                    Text(
                      listing.state.name.capitalize!,
                      style: text2.copyWith(color: kWhiteColor5),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "\$${listing.price.round()}",
                          style: headline3.copyWith(color: kPrimaryColor, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          timeago.format(listing.created, locale: 'en_short'),
                          style: headline3.copyWith(color: kWhiteColor3),
                        ),
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
