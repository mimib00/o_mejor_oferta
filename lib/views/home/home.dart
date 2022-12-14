import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/home/components/listing_tile.dart';
import 'package:mejor_oferta/views/home/controller/home_controller.dart';
import 'package:unicons/unicons.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: kPrimaryColor5,
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            automaticallyImplyLeading: false,
            centerTitle: false,
            toolbarHeight: kToolbarHeight + 10,
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
              labelPadding: EdgeInsets.zero,
              indicatorColor: Colors.transparent,
              tabs: [
                Tab(
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(UniconsLine.location_point),
                      const SizedBox(width: 5),
                      const Text("Location"),
                      const Spacer(),
                      Container(
                        height: 20,
                        width: 1.0,
                        color: kWhiteColor5,
                      )
                    ],
                  ),
                ),
                Tab(
                  child: Row(
                    children: [
                      const SizedBox(width: 10),
                      const Icon(UniconsLine.web_grid),
                      const SizedBox(width: 5),
                      const Text("Category"),
                      const Spacer(),
                      Container(
                        height: 20,
                        width: 1.0,
                        color: kWhiteColor5,
                      )
                    ],
                  ),
                ),
                const Tab(
                  child: Icon(UniconsLine.filter),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: FutureBuilder<List<ListingThumb>>(
              future: controller.getListings(),
              builder: (context, snapshot) {
                if (snapshot.data == null || snapshot.data!.isEmpty) return Container();
                final listings = snapshot.data!;
                return GridView.builder(
                  itemCount: listings.length,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: .7,
                  ),
                  itemBuilder: (context, index) {
                    return ListingTile(listing: listings[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
