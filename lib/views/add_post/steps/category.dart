import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/meta/models/category.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/add_post/components/category_tile.dart';
import 'package:mejor_oferta/views/add_post/controller/add_post_controller.dart';
import 'package:mejor_oferta/views/membership/membership.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CategoryStep extends GetView<AddPostController> {
  const CategoryStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select category",
            style: headline3,
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<Category>>(
            future: controller.getCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: kPrimaryColor));
              }
              if (snapshot.data == null || snapshot.data!.isEmpty) return Container();
              final categories = snapshot.data!;
              return Obx(
                () {
                  final user = Authenticator.instance.user.value!;
                  return GridView.builder(
                    itemCount: categories.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return CategoryTile(
                        onTap: () {
                          final paidCategories = ["Adult Entertainment"];

                          if (paidCategories.contains(categories[index].name) && !user.nsfwAllowed) {
                            Get.to(() => MembershipScreen(category: categories[index]));
                          } else {
                            controller.category = categories[index];
                            controller.next();
                          }
                        },
                        category: categories[index],
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
