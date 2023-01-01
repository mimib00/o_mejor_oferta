import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/models/attributes.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/text_input.dart';
import 'package:mejor_oferta/views/add_post/components/image_selector.dart';
import 'package:mejor_oferta/views/add_post/controller/add_post_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AttributeInput extends GetView<AddPostController> {
  final Attributes attribute;
  AttributeInput({
    super.key,
    required this.attribute,
  });
  final TextEditingController input = TextEditingController();
  final GlobalKey<FormState> form = GlobalKey();
  @override
  Widget build(BuildContext context) {
    Widget child = Container();
    log(attribute.title);
    log(attribute.type.name);
    switch (attribute.type) {
      case AttributeTypes.number:
        child = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomTextInput(
              controller: input,
              labelText: attribute.title,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (attribute.required && value == null || value!.isEmpty) return "Field required";
                return null;
              },
              onChanged: (value) {
                if (value == null || value.isEmpty) {
                  controller.attributes.removeWhere((element) => element["possible_attribute"] == attribute.id);
                  return;
                }
                if (controller.attributes
                    .where((element) => element["possible_attribute"] == attribute.id)
                    .isNotEmpty) {
                  controller.attributes.removeWhere((element) => element["possible_attribute"] == attribute.id);
                }
                final data = {
                  "value": value,
                  "possible_attribute": attribute.id,
                };
                if (attribute.title.toLowerCase() == "price") controller.price = value;
                controller.attributes.add(data);
              },
            ),
            Obx(
              () {
                return Visibility(
                  visible: attribute.title == "Price",
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        visualDensity: VisualDensity.compact,
                        value: controller.negotiable.value,
                        activeColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        side: const BorderSide(width: 1.5, color: kWhiteColor3),
                        onChanged: (value) {
                          if (value == null) return;
                          controller.negotiable.value = value;
                          controller.update();
                        },
                      ),
                      Text(
                        "Negotiable",
                        style: text2,
                      )
                    ],
                  ),
                );
              },
            )
          ],
        );
        break;
      case AttributeTypes.text:
        child = CustomTextInput(
          controller: input,
          labelText: attribute.title,
          validator: (value) {
            if (attribute.required && value == null || value!.isEmpty) return "Field required";
            return null;
          },
          onChanged: (value) {
            if (value == null || value.isEmpty) {
              controller.attributes.removeWhere((element) => element["possible_attribute"] == attribute.id);
              return;
            }
            if (controller.attributes.where((element) => element["possible_attribute"] == attribute.id).isNotEmpty) {
              controller.attributes.removeWhere((element) => element["possible_attribute"] == attribute.id);
            }
            final data = {
              "value": value,
              "possible_attribute": attribute.id,
              "title": value,
            };
            if (attribute.title.toLowerCase() == "title") controller.title = value;
            controller.attributes.add(data);
          },
        );
        break;
      case AttributeTypes.boolean:
        break;
      case AttributeTypes.checkbox:
        break;
      case AttributeTypes.radiobox:
        child = Obx(
          () {
            return Column(
              children: attribute.choices.map(
                (e) {
                  final values =
                      controller.attributes.where((element) => element["possible_attribute"] == attribute.id).isEmpty
                          ? ""
                          : controller.attributes
                              .where((element) => element["possible_attribute"] == attribute.id)
                              .first["value"];
                  return RadioListTile(
                    title: Text(e.capitalize ?? ""),
                    value: e.toLowerCase(),
                    activeColor: kPrimaryColor,
                    contentPadding: EdgeInsets.zero,
                    enableFeedback: false,
                    groupValue: values,
                    onChanged: (value) {
                      if (controller.attributes
                          .where((element) => element["possible_attribute"] == attribute.id)
                          .isNotEmpty) {
                        controller.attributes.removeWhere((element) => element["possible_attribute"] == attribute.id);
                      }
                      final data = {
                        "value": value,
                        "possible_attribute": attribute.id,
                      };
                      controller.attributes.add(data);
                    },
                  );
                },
              ).toList(),
            );
          },
        );
        break;
      case AttributeTypes.images:
        child = const ImageSelector();
        break;
      case AttributeTypes.textarea:
        child = CustomTextInput(
          controller: input,
          labelText: attribute.title,
          lines: 8,
          validator: (value) {
            if (attribute.required && value == null || value!.isEmpty) return "Field required";
            return null;
          },
          onChanged: (value) {
            if (value == null || value.isEmpty) {
              controller.attributes.removeWhere((element) => element["possible_attribute"] == attribute.id);
              return;
            }
            if (controller.attributes.where((element) => element["possible_attribute"] == attribute.id).isNotEmpty) {
              controller.attributes.removeWhere((element) => element["possible_attribute"] == attribute.id);
            }
            final data = {
              "value": value,
              "possible_attribute": attribute.id,
            };
            if (attribute.title.toLowerCase() == "description") controller.description = value;
            controller.attributes.add(data);
          },
        );
        break;
    }
    return Form(
      key: form,
      child: Column(
        children: [
          child,
          SizedBox(height: 10.h),
          Obx(
            () {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: controller.images.isEmpty
                          ? controller.attributes
                                  .where((element) => element["possible_attribute"] == attribute.id)
                                  .isEmpty
                              ? null
                              : () {
                                  controller.nextInfo();
                                }
                          : () {
                              controller.postListing();
                            },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        textStyle: headline3,
                      ),
                      child: const Text("Next"),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
