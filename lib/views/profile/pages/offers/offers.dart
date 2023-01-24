import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/profile/controller/offers_controller.dart';
import 'package:mejor_oferta/views/profile/pages/offers/tabs/my_offer.dart';
import 'package:mejor_oferta/views/profile/pages/offers/tabs/offered.dart';

class MyOfferScreen extends GetView<OfferController> {
  const MyOfferScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Offers"),
        bottom: TabBar(
          controller: controller.tabController,
          indicatorColor: kPrimaryColor,
          labelColor: kPrimaryColor,
          unselectedLabelColor: Colors.black,
          labelStyle: text1,
          tabs: const [
            Tab(
              text: "Offered",
            ),
            Tab(
              text: "My Offers",
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: controller.tabController,
        children: const [
          MyOfferTab(),
          OfferedTab(),
        ],
      ),
    );
  }
}
