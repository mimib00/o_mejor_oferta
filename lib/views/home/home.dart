import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/add_post/components/location_sheet.dart';
import 'package:mejor_oferta/views/home/components/carousel_tile.dart';
import 'package:mejor_oferta/views/home/components/category_sheet.dart';
import 'package:mejor_oferta/views/home/components/filter_sheet.dart';
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
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            expandedHeight: 170,
            pinned: true,
            actions: [
              IconButton(
                onPressed: () => Get.toNamed(Routes.notification),
                icon: const Icon(Icons.notifications_outlined),
              ),
            ],
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
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 50),
                    padding: const EdgeInsets.all(8),
                    color: Colors.white,
                    child: TextFormField(
                      decoration: InputDecoration(
                        prefixIcon: const Icon(
                          UniconsLine.search,
                          color: kPrimaryColor,
                        ),
                        hintText: "Search",
                        isDense: true,
                        border: OutlineInputBorder(borderSide: BorderSide.none, borderRadius: BorderRadius.circular(10)),
                        fillColor: kPrimaryColor5,
                        filled: true,
                      ),
                      onChanged: (value) {
                        controller.query.value = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            bottom: TabBar(
              controller: controller.tabController,
              labelPadding: EdgeInsets.zero,
              indicatorColor: Colors.transparent,
              onTap: (value) {
                switch (value) {
                  case 0:
                    Get.bottomSheet(
                      LocationSheet(
                        onTap: (state) {
                          controller.stop = false;
                          controller.page = 1;
                          controller.state = state.id;
                          controller.pagingController.refresh();
                        },
                        onReset: () {
                          controller.stop = false;
                          controller.page = 1;
                          controller.state = null;
                          Get.back();
                          controller.pagingController.refresh();
                        },
                      ),
                    );
                    break;
                  case 1:
                    Get.bottomSheet(
                      CategorySheet(
                        onTap: (category) {
                          controller.stop = false;
                          controller.page = 1;
                          controller.category = category.id;
                          controller.pagingController.refresh();
                          Get.back();
                        },
                        onReset: () {
                          controller.stop = false;
                          controller.page = 1;
                          controller.category = null;
                          Get.back();
                          controller.pagingController.refresh();
                          Get.back();
                        },
                      ),
                    );
                    break;
                  case 2:
                    Get.bottomSheet(
                      FilterSheet(
                        onTap: (priceLTE, priceGTE, order) {
                          controller.stop = false;
                          controller.page = 1;
                          controller.order = order;
                          controller.pagingController.refresh();
                          Get.back();
                        },
                        onReset: () {
                          controller.stop = false;
                          controller.page = 1;
                          controller.order = null;
                          controller.priceGTE = null;
                          controller.priceLTE = null;
                          controller.pagingController.refresh();
                          Get.back();
                        },
                      ),
                    );
                    break;
                }
              },
              tabs: [
                Container(
                  color: Colors.white,
                  child: Tab(
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
                ),
                Container(
                  color: Colors.white,
                  child: Tab(
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
                ),
                Container(
                  color: Colors.white,
                  child: Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(UniconsLine.filter),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                [
                  Obx(
                    () {
                      return controller.query.value.isEmpty
                          ? FutureBuilder<List<ListingThumb>>(
                              future: controller.getBoostedPosts(),
                              builder: (context, snapshot) {
                                if (snapshot.data == null || snapshot.data!.isEmpty) return Container();
                                final listings = snapshot.data!;
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: CarouselSlider(
                                    items: listings.map((e) => CarouselTile(listing: e)).toList(),
                                    options: CarouselOptions(viewportFraction: 1),
                                  ),
                                );
                              },
                            )
                          : Container();
                    },
                  ),
                  PagedGridView<int, ListingThumb>(
                    showNewPageProgressIndicatorAsGridChild: false,
                    showNoMoreItemsIndicatorAsGridChild: false,
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: .7,
                    ),
                    pagingController: controller.pagingController,
                    builderDelegate: PagedChildBuilderDelegate<ListingThumb>(
                      newPageProgressIndicatorBuilder: (context) => Container(),
                      noItemsFoundIndicatorBuilder: (context) => Center(
                        child: Text(
                          "No Posts Here 🙃",
                          style: Theme.of(context).textTheme.headline5!.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ),
                      itemBuilder: (context, item, index) {
                        return ListingTile(listing: item);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
