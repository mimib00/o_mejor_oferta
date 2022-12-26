import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            onPressed: () {},
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
        bottom: TabBar(
          controller: controller.tabController,
          indicatorColor: kPrimaryColor,
          labelColor: kPrimaryColor,
          unselectedLabelColor: Colors.black,
          labelStyle: text1,
          tabs: const [
            Tab(
              text: "Selling",
            ),
            Tab(
              text: "Sold",
            ),
            Tab(
              text: "Archive",
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
