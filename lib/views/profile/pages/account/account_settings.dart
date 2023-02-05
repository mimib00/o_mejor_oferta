import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/profile/controller/account_controller.dart';
import 'package:mejor_oferta/views/profile/pages/account/sections/email/email.dart';
import 'package:mejor_oferta/views/profile/pages/account/sections/facebook/facebook.dart';
import 'package:mejor_oferta/views/profile/pages/account/sections/location/location.dart';
import 'package:mejor_oferta/views/profile/pages/account/sections/name/name.dart';
import 'package:mejor_oferta/views/profile/pages/account/sections/phone/phone.dart';
import 'package:unicons/unicons.dart';

class AccountSettings extends GetView<AccountController> {
  const AccountSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("account_settings_title".tr),
      ),
      body: Obx(
        () {
          final user = Authenticator.instance.user.value!;
          return ListView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            children: [
              ListTile(
                onTap: () => Get.to(() => NameSection(), arguments: user.name),
                horizontalTitleGap: 0,
                leading: const Icon(UniconsLine.user),
                title: Text(
                  user.name,
                  style: text1,
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
              ListTile(
                onTap: () => Get.to(() => EmailSection(), arguments: user.email),
                horizontalTitleGap: 0,
                leading: const Icon(Icons.email_outlined),
                title: Text(
                  user.email,
                  style: text1,
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
              ListTile(
                onTap: () => Get.to(() => PhoneSection(), arguments: user.phone),
                horizontalTitleGap: 0,
                leading: const Icon(UniconsLine.phone),
                title: Text(
                  user.phone,
                  style: text1,
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
              ListTile(
                onTap: () => Get.to(() => const LocationSection(), arguments: user.state),
                horizontalTitleGap: 0,
                leading: const Icon(UniconsLine.location_point),
                title: Text(
                  user.state ?? "not_set".tr,
                  style: text1,
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
              ListTile(
                onTap: () => Get.to(() => FacebookSection(), arguments: user.facebookHandle),
                horizontalTitleGap: 0,
                leading: const Icon(UniconsLine.facebook_f),
                title: Text(
                  user.facebookHandle ?? "not_set".tr,
                  style: text1,
                ),
                trailing: const Icon(Icons.arrow_forward_ios_rounded),
              ),
              ListTile(
                onTap: () {
                  Get.defaultDialog(
                    title: "delete_title".tr,
                    content: Text(
                      "delete_body".tr,
                      textAlign: TextAlign.center,
                    ),
                    confirm: TextButton(
                      onPressed: () => Authenticator.instance.deleteUser(),
                      child: Text(
                        "yes".tr,
                        style: const TextStyle(color: kWarningColor),
                      ),
                    ),
                    cancel: TextButton(
                      onPressed: () => Get.back(),
                      child: Text(
                        "no".tr,
                      ),
                    ),
                  );
                },
                horizontalTitleGap: 0,
                title: Text(
                  "delete_account_btn".tr,
                  style: text1.copyWith(color: kWarningColor),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
