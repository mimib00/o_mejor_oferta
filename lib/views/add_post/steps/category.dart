import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/models/category.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/add_post/components/category_tile.dart';
import 'package:mejor_oferta/views/add_post/controller/add_post_controller.dart';
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
          const SizedBox(height: 5),
          Text(
            "Choose an option below to post an ad",
            style: text2,
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
                      controller.category = categories[index];
                      controller.next();
                    },
                    category: categories[index],
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