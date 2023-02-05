import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/models/chat.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
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
    final listing = Get.arguments as Listing;

    return Scaffold(
      appBar: AppBar(
        title: Text("dashboard_title".tr),
        actions: [
          IconButton(
            onPressed: () {
              showCupertinoModalPopup(
                context: context,
                builder: (context) => CupertinoActionSheet(
                  actions: [
                    CupertinoActionSheetAction(
                      onPressed: () async {
                        await controller.archive(listing.id);
                        Get.back();
                        Get.back();
                      },
                      child: Text(
                        "archive_title".tr,
                        style: headline3.copyWith(color: kPrimaryColor),
                      ),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () {
                        Get.back();
                        Get.toNamed(Routes.post, parameters: {"id": listing.id.toString()});
                      },
                      child: Text(
                        "view_post_btn".tr,
                        style: headline3.copyWith(color: kPrimaryColor),
                      ),
                    ),
                    CupertinoActionSheetAction(
                      onPressed: () {
                        Get.back();
                        Get.toNamed(Routes.editPost, arguments: listing);
                      },
                      child: Text(
                        "edit_post_btn".tr,
                        style: headline3.copyWith(color: kPrimaryColor),
                      ),
                    ),
                  ],
                  cancelButton: CupertinoActionSheetAction(
                    onPressed: () => Get.back(),
                    child: Text(
                      "cancel_btn".tr,
                      style: headline3.copyWith(color: kPrimaryColor),
                    ),
                  ),
                ),
              );
            },
            icon: const Icon(Icons.more_vert_rounded),
          )
        ],
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
                      imageUrl: listing.images.isNotEmpty ? listing.images.first : "",
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
            Visibility(
              visible: listing.status == ListingStatus.published,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 5.w),
                    child: ElevatedButton(
                      onPressed: () => controller.markSold(),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 12),
                        textStyle: headline3.copyWith(fontWeight: FontWeight.bold),
                      ),
                      child: Text("mark_sold_btn".tr),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(right: 5.w),
                    child: ElevatedButton.icon(
                      onPressed: () => Get.toNamed(Routes.boost, arguments: listing),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 10),
                        textStyle: headline3.copyWith(fontWeight: FontWeight.bold),
                      ),
                      label: Text("sell_fast_btn".tr),
                      icon: const Icon(Icons.keyboard_double_arrow_up_sharp),
                    ),
                  ),
                ],
              ),
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
                "prefomance_btn".tr,
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
              future: controller.getListingThreads(listing.id),
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
