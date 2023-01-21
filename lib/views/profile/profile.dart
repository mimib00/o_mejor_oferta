import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/profile/components/profile_info.dart';
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
              ProfileInfoTile(user: user),
              SizedBox(height: 3.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Offers",
                      style: headline2,
                    ),
                    ProfileTile(icon: UniconsLine.dollar_alt, title: "My Offers", onTap: () => Get.toNamed(Routes.profileOffers)),
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
