import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/controller/locale_controller.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/profile/components/profile_info.dart';
import 'package:mejor_oferta/views/profile/components/profile_tile.dart';
import 'package:mejor_oferta/views/profile/components/verification_tile.dart';
import 'package:mejor_oferta/views/profile/controller/profile_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final LocaleController localeController = Get.find();
    String value = localeController.locale.value!.languageCode;
    return Scaffold(
      appBar: AppBar(
        title: Text("profile_title".tr),
        actions: [
          Visibility(
            visible: Authenticator.instance.user.value != null,
            child: TextButton(
              onPressed: () => Authenticator.instance.logout(),
              child: Text("logout_btn".tr),
            ),
          ),
        ],
      ),
      body: Obx(
        () {
          final user = Authenticator.instance.user.value;
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              ProfileInfoTile(
                user: user,
                changePhoto: true,
              ),
              SizedBox(height: 3.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: user != null,
                      child: Text(
                        "verify_title".tr,
                        style: text1.copyWith(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 5),
                    Visibility(
                      visible: user != null,
                      child: Row(
                        children: [
                          VerificationTile(
                            icon: Icons.email_outlined,
                            title: "email_verification_title".tr,
                            active: true,
                          ),
                          VerificationTile(
                            icon: UniconsLine.phone,
                            title: "phone_verification_title".tr,
                            active: true,
                          ),
                          VerificationTile(
                            onTap: () {
                              launchUrl(Uri.parse(user?.facebookHandle! ?? ""));
                            },
                            icon: UniconsLine.facebook_f,
                            title: "facebook_verification_title".tr,
                            active: user?.facebookHandle != null,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Visibility(
                      visible: user != null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "transactions_title".tr,
                            style: headline2,
                          ),
                          ProfileTile(
                            icon: UniconsLine.dollar_alt,
                            title: "purchased_items_title".tr,
                            onTap: () => Get.toNamed(Routes.profileBought),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: user != null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "offers_title".tr,
                            style: headline2,
                          ),
                          ProfileTile(
                            icon: UniconsLine.pricetag_alt,
                            title: "my_offers_title".tr,
                            onTap: () => Get.toNamed(Routes.profileOffers),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: user != null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "saves_title".tr,
                            style: headline2,
                          ),
                          ProfileTile(
                            icon: UniconsLine.star,
                            title: "saved_title".tr,
                            onTap: () => Get.toNamed(Routes.profileSaved),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: user != null,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "account_title".tr,
                            style: headline2,
                          ),
                          ProfileTile(
                            icon: UniconsLine.setting,
                            title: "account_settings_title".tr,
                            onTap: () => Get.toNamed(Routes.profileAccount),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      "help_title".tr,
                      style: headline2,
                    ),
                    StatefulBuilder(
                      builder: (context, setState) {
                        return ProfileTile(
                          icon: Icons.language,
                          title: "language_title".tr,
                          trailing: DropdownButton(
                            value: value,
                            underline: const SizedBox.shrink(),
                            items: [
                              DropdownMenuItem(
                                value: 'es',
                                child: Text('es'.tr),
                              ),
                              DropdownMenuItem(
                                value: 'en',
                                child: Text('en'.tr),
                              ),
                            ],
                            onChanged: (val) {
                              if (val == null) return;
                              setState(
                                () {
                                  value = val;
                                },
                              );
                              localeController.saveLocale(value);
                            },
                          ),
                        );
                      },
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
