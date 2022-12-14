import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/models/brand.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/add_post/controller/add_post_controller.dart';

class BrandsStep extends GetView<AddPostController> {
  final List<Brand> brands;
  final bool isBrands;
  const BrandsStep({
    super.key,
    required this.brands,
    this.isBrands = true,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: brands.length,
      physics: const BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return ListTile(
          onTap: () async {
            if (isBrands) {
              Get.dialog(
                const Center(
                  child: CircularProgressIndicator(
                    color: kPrimaryColor,
                  ),
                ),
                barrierDismissible: false,
              );
              controller.brand = brands[index];
              await controller.getProducts();
              Get.back();
              controller.nextInfo();
            } else {
              controller.product = brands[index];
              controller.nextInfo();
            }
          },
          title: Text(brands[index].name),
        );
      },
    );
  }
}
