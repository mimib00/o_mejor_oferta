import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/models/chat.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/loading.dart';
import 'package:mejor_oferta/views/dashboard/controller/dashboard_controller.dart';
import 'package:mejor_oferta/views/dashboard/stats.dart';
import 'package:mejor_oferta/views/inbox/components/inbox_tile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:unicons/unicons.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final listing = Get.arguments;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Item dashboard"),
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
                      imageUrl: listing?.images.first ?? "",
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        listing?.title ?? "",
                        style: text1,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "\$${listing?.price}",
                        style: headline3,
                      ),
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 30),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10.w),
                  child: ElevatedButton(
                    onPressed: () => controller.markSold(),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 12),
                      textStyle: headline3.copyWith(fontWeight: FontWeight.bold),
                    ),
                    child: const Text("Mark as sold"),
                  ),
                ),
                const Spacer(),
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: ElevatedButton.icon(
                    onPressed: () => Get.toNamed(Routes.boost, arguments: listing),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 10),
                      textStyle: headline3.copyWith(fontWeight: FontWeight.bold),
                    ),
                    label: const Text("Sell faster"),
                    icon: const Icon(Icons.keyboard_double_arrow_up_sharp),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ListTile(
              onTap: () => Get.to(() => const StatsScreen()),
              contentPadding: const EdgeInsets.symmetric(horizontal: 10),
              leading: const Icon(
                UniconsLine.heart_rate,
                color: kPrimaryColor,
              ),
              title: Text(
                "Item preformance",
                style: headline3,
              ),
              trailing: const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Colors.black,
                size: 20,
              ),
            ),
            const Divider(
              indent: 30,
              endIndent: 30,
              thickness: 1,
            ),
            FutureBuilder<List<InboxThread>>(
              future: controller.getListingThreads(listing?.id ?? 0),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: Loading());
                if (snapshot.data == null) return Container();
                final threads = snapshot.data!;
                return ListView.builder(
                  itemCount: threads.length,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    return InboxTile(thread: threads[index]);
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
