import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/models/category.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/add_post/controller/add_post_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SubCategoryStep extends GetView<AddPostController> {
  const SubCategoryStep({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Select subcategory",
            style: headline3,
          ),
          const SizedBox(height: 20),
          FutureBuilder<List<Category>>(
            future: controller.getSubCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: kPrimaryColor));
              }
              if (snapshot.data == null || snapshot.data!.isEmpty) return Container();
              final categories = snapshot.data!;
              return ListView.builder(
                itemCount: categories.length,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  final sub = categories[index];
                  return ListTile(
                    onTap: () {
                      controller.subCategory = sub;

                      controller.next();
                    },
                    title: Text(sub.name),
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
