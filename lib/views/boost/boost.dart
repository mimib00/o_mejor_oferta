import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:mejor_oferta/meta/models/packages.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/loading.dart';
import 'package:mejor_oferta/views/boost/components/package_tile.dart';
import 'package:mejor_oferta/views/boost/controller/boost_controller.dart';
import 'package:unicons/unicons.dart';

class BoosterScreen extends GetView<BoostController> {
  const BoosterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Listing listing = Get.arguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sell Faster"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: listing.images.first,
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return Container(
                          alignment: Alignment.center,
                          color: kPrimaryColor,
                          child: const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        listing.title,
                        style: text1,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "\$${listing.price}",
                        style: headline3,
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            FutureBuilder<List<Packages>>(
              future: controller.getPackages(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Loading());

                if (snapshot.data == null || snapshot.data!.isEmpty) return Container();

                final packages = snapshot.data!;

                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: packages.length,
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    physics: const BouncingScrollPhysics(),
                    itemExtent: 200,
                    itemBuilder: (context, index) {
                      return PackageTile(
                        package: packages[index],
                        id: listing.id,
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(
                        UniconsLine.check,
                        color: kPrimaryColor,
                      ),
                      Text(
                        "Get an average of 20x more views each day.",
                        style: text1,
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(
                        UniconsLine.check,
                        color: kPrimaryColor,
                      ),
                      Text(
                        "Promote for multiple days.",
                        style: text1,
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Icon(
                        UniconsLine.check,
                        color: kPrimaryColor,
                      ),
                      Text(
                        "Switch promotion to any item.",
                        style: text1,
                      )
                    ],
                  ),
                  const SizedBox(height: 50),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () => Get.toNamed(Routes.boostHow),
                        child: Text(
                          "How does promoting work?",
                          style: headline3.copyWith(color: kPrimaryColor),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
