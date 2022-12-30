import 'package:flutter/material.dart';
import 'package:mejor_oferta/views/boost/components/how_tile.dart';

class BoostHowScreen extends StatelessWidget {
  const BoostHowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("How boosting works"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, top: 40),
        child: Column(
          children: const [
            HowTile(
              image: "assets/phone1.png",
              title: "Get more views",
              info: "Promoted posts appear among the first spots buyers see and get an average of 14x more views.",
            ),
            HowTile(
              image: "assets/phone2.png",
              title: "Add a boosted spot",
              info: "Your item appears as a new post in search results as well as in the promoted spot.",
            ),
            HowTile(
              image: "assets/phone3.png",
              title: "Boosted spots are shared",
              info: "Don’t worry if you don’t see your item at the top of the feed. Spots are shared between sellers",
            ),
          ],
        ),
      ),
    );
  }
}
