import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:map/map.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/loading.dart';
import 'package:mejor_oferta/meta/widgets/main_button.dart';
import 'package:mejor_oferta/views/offer/controller/offers_controller.dart';
import 'package:mejor_oferta/views/post/components/attribute_tile.dart';
import 'package:mejor_oferta/views/post/controller/post_controller.dart';
import 'package:mejor_oferta/views/post/seller_profile.dart';
import 'package:readmore/readmore.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:unicons/unicons.dart';

class PostScreen extends GetView<PostController> {
  const PostScreen({super.key});

  Widget buildMarkerWidget(Offset pos, Color color, [IconData icon = Icons.location_on]) {
    return Positioned(
      left: pos.dx - 25,
      top: pos.dy - 25,
      width: 60,
      height: 60,
      child: const Icon(
        Icons.location_pin,
        size: 35,
        color: kPrimaryColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        if (controller.listing.value == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text("details_title".tr),
            ),
            body: const Center(
              child: Loading(),
            ),
          );
        }
        final listing = controller.listing.value!;
        final saved = controller.saved.value;
        final me = Authenticator.instance.user.value;
        final mine = listing.owner.id != me?.id;
        return Scaffold(
          appBar: AppBar(
            title: Text("details_title".tr),
            actions: [
              Visibility(
                visible: me != null,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Get.toNamed(Routes.postReport, parameters: {"id": listing.id.toString()}),
                      child: const Icon(UniconsLine.ban),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () async => await controller.toggleSave(),
                      child: Icon(
                        saved ? Icons.star_rounded : Icons.star_outline,
                        color: saved ? Colors.yellow : null,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Visibility(
                      visible: !mine,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () => Get.toNamed(Routes.editPost, arguments: listing),
                            child: Icon(
                              UniconsLine.edit,
                              color: saved ? Colors.yellow : null,
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              CarouselSlider.builder(
                carouselController: controller.carouselController,
                itemCount: listing.images.length,
                itemBuilder: (context, index, realIndex) {
                  return CachedNetworkImage(
                    imageUrl: listing.images[index],
                    errorWidget: (context, url, error) {
                      return Container(
                        alignment: Alignment.center,
                        color: kPrimaryColor,
                        child: const Icon(Icons.error),
                      );
                    },
                  );
                },
                options: CarouselOptions(
                  height: 35.h,
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  onPageChanged: (index, reason) {
                    controller.index.value = index;
                    controller.update();
                  },
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      listing.images.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: index == controller.index.value ? kPrimaryColor : Colors.white,
                          border: Border.all(color: kPrimaryColor),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      listing.title,
                      style: headline1,
                    ),
                    Text(
                      "${'posted_on'.tr} ${DateFormat("dd-mm-yyy hh:mm a").format(listing.created)} ${listing.state.name}",
                      style: text2.copyWith(color: kWhiteColor4),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: const Divider(),
                    ),
                    Row(
                      children: [
                        Text(
                          "\$${listing.price.round()}",
                          style: headline1.copyWith(color: kPrimaryColor),
                        ),
                        const SizedBox(width: 15),
                        Visibility(
                          visible: listing.isNegotiable,
                          child: Text(
                            "Negotiable",
                            style: text2.copyWith(color: kWhiteColor4),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Text(
                          "sale_by".tr,
                          style: text2.copyWith(color: kWhiteColor4),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => SellerProfile(id: listing.owner.id));
                          },
                          child: Text(
                            listing.owner.name,
                            style: headline3.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: const Divider(),
                    ),
                    Text(
                      "features_title".tr,
                      style: headline3.copyWith(fontWeight: FontWeight.w600),
                    ),
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      shrinkWrap: true,
                      itemCount: listing.attributes.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 5,
                      ),
                      itemBuilder: (context, index) {
                        return AttributeTile(attribute: listing.attributes[index]);
                      },
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 2.h),
                      child: const Divider(),
                    ),
                    Text(
                      "description_title".tr,
                      style: headline3.copyWith(fontWeight: FontWeight.w600),
                    ),
                    ReadMoreText(
                      listing.description,
                      trimLines: 2,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: 'Show more',
                      trimExpandedText: ' Show less',
                      moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kPrimaryColor),
                      lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: kPrimaryColor),
                    ),
                    const SizedBox(height: 15),
                    SizedBox(
                      height: 200,
                      width: Get.width,
                      child: MapLayout(
                        controller: controller.controller,
                        builder: (context, transformer) {
                          final markerPositions = controller.markers.map(transformer.toOffset).toList();
                          final markerWidgets = markerPositions.map(
                            (pos) => buildMarkerWidget(pos, Colors.red),
                          );
                          return Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: TileLayer(
                                  builder: (context, x, y, z) {
                                    final tilesInZoom = pow(2.0, z).floor();

                                    while (x < 0) {
                                      x += tilesInZoom;
                                    }
                                    while (y < 0) {
                                      y += tilesInZoom;
                                    }

                                    x %= tilesInZoom;
                                    y %= tilesInZoom;

                                    //Google Maps
                                    final url =
                                        'https://www.google.com/maps/vt/pb=!1m4!1m3!1i$z!2i$x!3i$y!2m3!1e0!2sm!3i420120488!3m7!2sen!5e1105!12m4!1e68!2m2!1sset!2sRoadmap!4e0!5m1!1e0!23i4111425';

                                    return CachedNetworkImage(
                                      imageUrl: url,
                                      fit: BoxFit.contain,
                                    );
                                  },
                                ),
                              ),
                              ...markerWidgets,
                            ],
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 25),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: mine
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: MainButton(
                            onTap: () {
                              final token = Authenticator.instance.fetchToken();
                              if (token.isEmpty) {
                                Get.offAllNamed(Routes.login);
                              } else {
                                final OffersController offersController = Get.put(OffersController());
                                offersController.createChatRoom(listings: listing);
                              }
                            },
                            text: "chat_btn".tr,
                          ),
                        ),
                        Expanded(
                          child: MainButton(
                            onTap: () {
                              final token = Authenticator.instance.fetchToken();
                              if (token.isEmpty) {
                                Get.offAllNamed(Routes.login);
                              } else {
                                Get.toNamed(Routes.offers, arguments: listing);
                              }
                            },
                            text: "make_offer_btn".tr,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15)
                  ],
                )
              : const SizedBox.shrink(),
        );
      },
    );
  }
}
