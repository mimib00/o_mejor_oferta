import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/profile/components/profile_tile.dart';
import 'package:mejor_oferta/views/profile/controller/profile_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:unicons/unicons.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        actions: [
          TextButton(
            onPressed: () => Authenticator.instance.logout(),
            child: const Text("Log out"),
          ),
        ],
      ),
      body: Obx(
        () {
          final user = Authenticator.instance.user.value!;
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                horizontalTitleGap: 0,
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(45),
                  child: CachedNetworkImage(
                    imageUrl: "",
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
                        ),
                      );
                    },
                  ),
                ),
                title: Text(
                  user.name,
                  style: headline2,
                ),
                subtitle: RatingBarIndicator(
                  rating: 4,
                  itemBuilder: (context, index) => const Icon(
                    UniconsSolid.star,
                    color: Colors.amber,
                  ),
                  itemCount: 5,
                  itemSize: 20,
                ),
              ),
              SizedBox(height: 3.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Transactions",
                      style: headline2,
                    ),
                    const ProfileTile(
                      icon: UniconsLine.dollar_alt,
                      title: "Purchases & Sales",
                    ),
                    const ProfileTile(
                      icon: UniconsLine.credit_card,
                      title: "Payment & Deposite methods",
                    ),
                    Text(
                      "Saves",
                      style: headline2,
                    ),
                    ProfileTile(
                      icon: UniconsLine.star,
                      title: "Save items",
                      onTap: () => Get.toNamed(Routes.profileSaved),
                    ),
                    Text(
                      "Account",
                      style: headline2,
                    ),
                    ProfileTile(
                      icon: UniconsLine.setting,
                      title: "Account settings",
                      onTap: () => Get.toNamed(Routes.profileAccount),
                    ),
                    Text(
                      "Help",
                      style: headline2,
                    ),
                    const ProfileTile(
                      icon: UniconsLine.question_circle,
                      title: "Help center",
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
