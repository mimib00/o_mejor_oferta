import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/models/category.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/home/controller/home_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CategorySheet extends GetView<HomeController> {
  final Function(Category category)? onTap;
  final Function()? onReset;
  const CategorySheet({
    super.key,
    this.onTap,
    this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75.h,
      padding: const EdgeInsets.all(15),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Locations",
                style: headline2.copyWith(fontWeight: FontWeight.bold),
              ),
              Visibility(
                visible: onReset != null,
                child: GestureDetector(
                  onTap: onReset,
                  child: Text(
                    "Reset",
                    style: text2.copyWith(fontWeight: FontWeight.bold, color: kPrimaryColor),
                  ),
                ),
              ),
            ],
          ),
          FutureBuilder<List<FullCategory>>(
            future: controller.getCategories(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(color: kPrimaryColor),
                );
              }
              if (snapshot.data == null || snapshot.data!.isEmpty) return Container();

              final categories = snapshot.data!;

              return Expanded(
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return CategoryTile(
                      category: categories[index],
                      onTap: (category) => onTap?.call(category),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final FullCategory category;
  final Function(Category category) onTap;
  const CategoryTile({
    super.key,
    required this.category,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        category.name,
        style: text1,
      ),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.centerLeft,
      childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
      children: category.children
          .map(
            (e) => ListTile(
              onTap: () => onTap.call(e),
              title: Text(
                e.name,
                style: text2,
              ),
            ),
          )
          .toList(),
    );
  }
}
