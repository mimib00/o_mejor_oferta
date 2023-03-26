import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/root/controller/navigator_controller.dart';
import 'package:unicons/unicons.dart';

class RootScreen extends GetView<NavigatorController> {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return Scaffold(
          body: controller.screen,
          floatingActionButton: FloatingActionButton(
            elevation: 5,
            onPressed: () {
              final token = Authenticator.instance.fetchToken();
              if (token.isEmpty) {
                Get.offAllNamed(Routes.login);
              } else {
                Get.toNamed(Routes.addPost);
              }
            },
            backgroundColor: kPrimaryColor,
            child: const Icon(
              UniconsLine.camera,
              size: 30,
            ),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
          bottomNavigationBar: BottomNavigationBar(
            onTap: (value) {
              final token = Authenticator.instance.fetchToken();

              if (token.isEmpty && (value != 0 && value != 4)) {
                Get.offAllNamed(Routes.login);
              } else {
                value == 2 ? null : controller.goto(value);
              }
            },
            currentIndex: controller.index.value,
            selectedItemColor: kPrimaryColor,
            unselectedItemColor: Colors.black,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(UniconsLine.home_alt),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(UniconsLine.comment),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: SizedBox.shrink(),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(UniconsLine.tag_alt),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Icon(UniconsLine.user),
                label: "",
              ),
            ],
          ),
        );
      },
    );
  }
}
