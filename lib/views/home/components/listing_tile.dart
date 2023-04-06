import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:timeago/timeago.dart' as timeago;

class ListingTile extends StatelessWidget {
  final ListingThumb listing;
  const ListingTile({
    super.key,
    required this.listing,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GestureDetector(
        onTap: () => Get.toNamed(Routes.post, parameters: {"id": listing.id.toString()}),
        child: listing.boosted
            ? Banner(
                location: BannerLocation.topStart,
                message: "promoted_title".tr,
                color: kPrimaryColor,
                child: Column(
                  children: [
                    Expanded(
                      child: CachedNetworkImage(
                        imageUrl: listing.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorWidget: (context, url, error) {
                          final data = {
                            "uid": Authenticator.instance.user.value?.id,
                            "created_at": FieldValue.serverTimestamp(),
                            "error": error,
                            "image": url,
                          };
                          FirebaseFirestore.instance.collection("errors").add(data);
                          return Container(
                            alignment: Alignment.center,
                            color: kPrimaryColor,
                            child: const Icon(Icons.error),
                          );
                        },
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            listing.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: text1,
                          ),
                          Text(
                            listing.state.name,
                            style: text2.copyWith(color: kWhiteColor5),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${listing.price.round()}",
                                style: headline3.copyWith(color: kPrimaryColor),
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
              )
            : Column(
                children: [
                  Expanded(
                    child: CachedNetworkImage(
                      imageUrl: listing.image,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorWidget: (context, url, error) {
                        return Container(
                          alignment: Alignment.center,
                          color: kPrimaryColor,
                          child: const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          listing.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: text1,
                        ),
                        Text(
                          listing.state.name,
                          style: text2.copyWith(color: kWhiteColor5),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$${listing.price.round()}",
                              style: headline3.copyWith(color: kPrimaryColor),
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
    );
  }
}
