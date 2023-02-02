import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/add_post/controller/add_post_controller.dart';
import 'package:mejor_oferta/views/edit_post/controller/edit_post_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ImageSelector extends GetView<AddPostController> {
  final bool editing;
  const ImageSelector({super.key, required this.editing});

  @override
  Widget build(BuildContext context) {
    final controller = editing ? Get.put(AddPostController()) : Get.find<AddPostController>();
    final editController = editing ? Get.find<EditPostController>() : Get.put(EditPostController());
    return Obx(
      () {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            editing
                ? editController.images.isEmpty
                    ? Container()
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: kWhiteColor3),
                        ),
                        child: Image.file(
                          File(editController.images.first.path),
                          height: 230,
                          width: 100.w,
                          fit: BoxFit.contain,
                        ),
                      )
                : controller.images.isEmpty
                    ? Container()
                    : Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: kWhiteColor3),
                        ),
                        child: Image.file(
                          File(controller.images.first.path),
                          height: 230,
                          width: 100.w,
                          fit: BoxFit.contain,
                        ),
                      ),
            const SizedBox(height: 15),
            GridView.builder(
              itemCount: 6,
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemBuilder: (context, index) {
                if (editing) {
                  XFile? image;
                  try {
                    image = editController.images[index];
                  } catch (e) {
                    image = null;
                  }
                  return ImageTile(
                    image: image,
                    index: index,
                    len: editController.images.length,
                    onTap: (photo) {
                      editController.images.add(photo);
                      editController.update();
                    },
                    onDelete: (photo) {
                      editController.images.removeWhere((element) => element.path == photo.path);
                      editController.update();
                    },
                  );
                } else {
                  XFile? image;
                  try {
                    image = controller.images[index];
                  } catch (e) {
                    image = null;
                  }
                  return ImageTile(
                    image: image,
                    index: index,
                    len: controller.images.length,
                    onTap: (photo) {
                      controller.images.add(photo);
                      controller.update();
                    },
                    onDelete: (photo) {
                      controller.images.removeWhere((element) => element.path == photo.path);
                      controller.update();
                    },
                  );
                }
              },
            ),
            const SizedBox(height: 15),
            Text(
              "Note: your first image will be cover later",
              style: text3.copyWith(color: kWhiteColor4),
            )
          ],
        );
      },
    );
  }
}

class ImageTile extends StatelessWidget {
  final XFile? image;
  final int index;
  final int len;
  final Function(XFile photo)? onTap;
  final Function(XFile photo)? onDelete;
  const ImageTile({
    super.key,
    required this.index,
    required this.len,
    this.image,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        if (index != len) return;
        final ImagePicker picker = ImagePicker();

        final photo = await picker.pickImage(source: ImageSource.gallery);
        if (photo == null) return;

        onTap?.call(photo);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: index == len ? kPrimaryColor : kWhiteColor3),
        ),
        child: image == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.collections_outlined,
                    color: index == len ? kPrimaryColor : kWhiteColor3,
                  ),
                  Visibility(
                    visible: index <= len,
                    child: Text(
                      "Add photo",
                      style: text2.copyWith(color: kPrimaryColor),
                    ),
                  )
                ],
              )
            : Stack(
                children: [
                  Positioned.fill(
                    child: Image.file(
                      File(image!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    right: 5,
                    top: 5,
                    child: GestureDetector(
                      onTap: () => onDelete?.call(image!),
                      child: const CircleAvatar(
                        backgroundColor: kWarningColor,
                        foregroundColor: Colors.white,
                        radius: 10,
                        child: Icon(
                          Icons.close_rounded,
                          size: 15,
                        ),
                      ),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
