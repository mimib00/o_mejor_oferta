import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/selling/controller/selling_controller.dart';
import 'package:mejor_oferta/views/selling/tabs/archived_tab.dart';
import 'package:mejor_oferta/views/selling/tabs/selling_tab.dart';
import 'package:mejor_oferta/views/selling/tabs/sold_tab.dart';

class SellingScreen extends GetView<SellingController> {
  const SellingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor5,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "O Mejor ",
              style: headline1.copyWith(fontWeight: FontWeight.w700),
            ),
            Text(
              "Oferta",
              style: headline1.copyWith(fontWeight: FontWeight.w700, color: kPrimaryColor),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.notification),
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
        bottom: TabBar(
          controller: controller.tabController,
          indicatorColor: kPrimaryColor,
          labelColor: kPrimaryColor,
          unselectedLabelColor: Colors.black,
          labelStyle: text1,
          tabs: [
            Tab(
              text: "selling_title".tr,
            ),
            Tab(
              text: "sold_title".tr,
            ),
            Tab(
              text: "archive_title".tr,
            )
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: const [
          SellingTab(),
          SoldTab(),
          ArchivedTab(),
        ],
      ),
    );
  }
}
