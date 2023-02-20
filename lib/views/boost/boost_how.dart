import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/views/boost/components/how_tile.dart';

class BoostHowScreen extends StatelessWidget {
  const BoostHowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("how_boost_work_title".tr),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
        child: Column(
          children: const [
            HowTile(
              image: "assets/phone1.png",
              title: "boost_how_1_title",
              info: "boost_how_1_msg",
            ),
            HowTile(
              image: "assets/phone2.png",
              title: "boost_how_2_title",
              info: "boost_how_2_msg",
            ),
            HowTile(
              image: "assets/phone3.png",
              title: "boost_how_3_title",
              info: "boost_how_3_msg",
            ),
          ],
        ),
      ),
    );
  }
}
