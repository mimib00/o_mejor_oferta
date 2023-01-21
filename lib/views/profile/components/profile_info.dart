import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:mejor_oferta/meta/models/user.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:unicons/unicons.dart';

class ProfileInfoTile extends StatelessWidget {
  final User user;
  const ProfileInfoTile({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Photo
        ClipRRect(
          borderRadius: BorderRadius.circular(180),
          child: CachedNetworkImage(
            imageUrl: user.photo ?? "",
            height: 80,
            width: 80,
            fit: BoxFit.cover,
            errorWidget: (context, url, error) {
              return Container(
                height: 80,
                width: 80,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: kPrimaryColor,
                ),
                child: const Icon(
                  UniconsLine.user,
                  color: Colors.white,
                  size: 40,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 20),
        // Info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: headline2,
            ),
            RatingBarIndicator(
              rating: user.rating,
              itemBuilder: (context, index) => const Icon(
                UniconsSolid.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 20,
            ),
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: user.bought.toString(),
                        style: headline3.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: " Bought",
                        style: text1,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: user.sold.toString(),
                        style: headline3.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: " Sold",
                        style: text1,
                      ),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
