import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/meta/models/attributes.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/text_input.dart';
import 'package:mejor_oferta/views/add_post/components/image_selector.dart';
import 'package:mejor_oferta/views/add_post/controller/add_post_controller.dart';
import 'package:mejor_oferta/views/edit_post/controller/edit_post_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AttributeInput extends StatelessWidget {
  final Attributes attribute;
  final bool editing;
  final Listing? listing;
  AttributeInput({
    super.key,
    required this.attribute,
    this.editing = false,
    this.listing,
  });

  final GlobalKey<FormState> form = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final controller = editing ? Get.put(AddPostController()) : Get.find<AddPostController>();
    final editController = editing ? Get.find<EditPostController>() : Get.put(EditPostController());
    final attrib = attribute.id < 0 ? null : listing?.attributes.firstWhere((element) => element.title == attribute.title);
    final TextEditingController input = TextEditingController(text: editing ? attrib?.value : '');

    Widget child = Container();

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
                if (editing) {
                  if (value == null || value.isEmpty) {
                    editController.attributes.removeWhere((element) => element["possible_attribute"] == attribute.id);
                    return;
                  }
                  if (editController.attributes.where((element) => element["possible_attribute"] == attribute.id).isNotEmpty) {
                    editController.attributes.removeWhere((element) => element["possible_attribute"] == attribute.id);
                  }
                  final data = {
                    "id": attrib?.id,
                    "value": value,
                    "possible_attribute": attribute.id,
                  };
                  if (attribute.title.toLowerCase() == "price") editController.price = value;
                  editController.attributes.add(data);
                } else {
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
                  if (attribute.title.toLowerCase() == "price") controller.price = value;
                  controller.attributes.add(data);
                }
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
                          if (editing) {
                            editController.negotiable.value = value;
                            editController.update();
                          } else {
                            controller.negotiable.value = value;
                            controller.update();
                          }
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
            final splitted = value.split(' ');
            if (editing) {
              for (var word in splitted) {
                if (editController.words.contains(word.toLowerCase())) return "Bad word found";
              }
            } else {
              for (var word in splitted) {
                if (controller.words.contains(word.toLowerCase())) return "Bad word found";
              }
            }
            return null;
          },
          onChanged: (value) {
            if (editing) {
              if (value == null || value.isEmpty) {
                editController.attributes.removeWhere((element) => element["possible_attribute"] == attribute.id);
                return;
              }
              if (editController.attributes.where((element) => element["possible_attribute"] == attribute.id).isNotEmpty) {
                editController.attributes.removeWhere((element) => element["possible_attribute"] == attribute.id);
              }
              final data = {
                "id": attrib?.id,
                "value": value,
                "possible_attribute": attribute.id,
                "title": value,
              };
              if (attribute.title.toLowerCase() == "title") editController.title = value;
              editController.attributes.add(data);
            } else {
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
            }
          },
        );
        break;
      case AttributeTypes.boolean:
        child = Obx(
          () {
            final attribs = [];
            if (editing) {
              for (var attrib in editController.attributes) {
                attribs.add(attrib['possible_attribute']);
              }
            } else {
              for (var attrib in controller.attributes) {
                attribs.add(attrib['possible_attribute']);
              }
            }
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  visualDensity: VisualDensity.compact,
                  value: attribs.contains(attribute.id),
                  activeColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  side: const BorderSide(width: 1.5, color: kWhiteColor3),
                  onChanged: (value) {
                    if (editing) {
                      if (attribs.contains(attribute.id)) {
                        editController.attributes.removeWhere((element) => element["possible_attribute"] == attribute.id);
                      } else {
                        final data = {
                          "id": attrib?.id,
                          "value": value.toString(),
                          "possible_attribute": attribute.id,
                        };
                        editController.attributes.add(data);
                      }
                    } else {
                      if (attribs.contains(attribute.id)) {
                        controller.attributes.removeWhere((element) => element["possible_attribute"] == attribute.id);
                      } else {
                        final data = {
                          "value": value.toString(),
                          "possible_attribute": attribute.id,
                        };
                        controller.attributes.add(data);
                      }
                    }
                  },
                ),
                Text(
                  'Is ${attribute.title}',
                  style: text2,
                ),
              ],
            );
          },
        );
        break;
      case AttributeTypes.checkbox:
        child = Obx(
          () {
            return Column(
              children: attribute.choices.map(
                (e) {
                  final attribs = [];
                  if (editing) {
                    for (var attrib in editController.attributes) {
                      attribs.add(attrib['item']);
                    }
                  } else {
                    for (var attrib in controller.attributes) {
                      attribs.add(attrib['item']);
                    }
                  }
                  return CheckboxListTile(
                    title: Text(e.capitalize ?? ""),
                    controlAffinity: ListTileControlAffinity.leading,
                    value: attribs.contains(e),
                    activeColor: kPrimaryColor,
                    contentPadding: EdgeInsets.zero,
                    enableFeedback: false,
                    checkboxShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    onChanged: (value) {
                      if (editing) {
                        if (attribs.contains(e)) {
                          editController.attributes.removeWhere((element) => element["item"] == e);
                        } else {
                          final data = {
                            "id": attrib?.id,
                            'item': e,
                            "value": e,
                            "possible_attribute": attribute.id,
                          };
                          editController.attributes.add(data);
                        }
                      } else {
                        if (attribs.contains(e)) {
                          controller.attributes.removeWhere((element) => element["item"] == e);
                        } else {
                          final data = {
                            'item': e,
                            "value": e,
                            "possible_attribute": attribute.id,
                          };
                          controller.attributes.add(data);
                        }
                      }
                    },
                  );
                },
              ).toList(),
            );
          },
        );
        break;
      case AttributeTypes.radiobox:
        child = Obx(
          () {
            return Column(
              children: attribute.choices.map(
                (e) {
                  dynamic values;
                  if (editing) {
                    values = editController.attributes.where((element) => element["possible_attribute"] == attribute.id).isEmpty
                        ? ''
                        : editController.attributes.where((element) => element["possible_attribute"] == attribute.id).first["value"];
                  } else {
                    values = controller.attributes.where((element) => element["possible_attribute"] == attribute.id).isEmpty
                        ? ""
                        : controller.attributes.where((element) => element["possible_attribute"] == attribute.id).first["value"];
                  }

                  return RadioListTile(
                    title: Text(e.capitalize ?? ""),
                    value: e.toLowerCase(),
                    activeColor: kPrimaryColor,
                    contentPadding: EdgeInsets.zero,
                    enableFeedback: false,
                    groupValue: values,
                    onChanged: (value) {
                      if (editing) {
                        if (editController.attributes.where((element) => element["possible_attribute"] == attribute.id).isNotEmpty) {
                          editController.attributes.removeWhere((element) => element["possible_attribute"] == attribute.id);
                        } else {
                          final data = {
                            "id": attrib?.id,
                            "value": value,
                            "possible_attribute": attribute.id,
                          };
                          editController.attributes.add(data);
                        }
                      } else {
                        if (controller.attributes.where((element) => element["possible_attribute"] == attribute.id).isNotEmpty) {
                          controller.attributes.removeWhere((element) => element["possible_attribute"] == attribute.id);
                        } else {
                          final data = {
                            "value": value,
                            "possible_attribute": attribute.id,
                          };
                          controller.attributes.add(data);
                        }
                      }
                    },
                  );
                },
              ).toList(),
            );
          },
        );
        break;
      case AttributeTypes.images:
        child = ImageSelector(editing: editing);
        break;
      case AttributeTypes.textarea:
        child = CustomTextInput(
          controller: input,
          labelText: attribute.title,
          lines: 8,
          validator: (value) {
            if (attribute.required && value == null || value!.trim().isEmpty) return "Field required";
            final splitted = value.split(' ');
            if (editing) {
              for (var word in splitted) {
                if (editController.words.contains(word.toLowerCase())) return "Bad word found";
              }
            } else {
              for (var word in splitted) {
                if (controller.words.contains(word.toLowerCase())) return "Bad word found";
              }
            }
            return null;
          },
          onChanged: (value) {
            if (editing) {
              if (value == null || value.isEmpty) {
                editController.attributes.removeWhere((element) => element["possible_attribute"] == attribute.id);
                return;
              }
              if (editController.attributes.where((element) => element["possible_attribute"] == attribute.id).isNotEmpty) {
                editController.attributes.removeWhere((element) => element["possible_attribute"] == attribute.id);
              }

              final data = {
                "id": attrib?.id,
                "value": value,
                "possible_attribute": attribute.id,
              };
              if (attribute.title.toLowerCase() == "description") editController.description = value;
              editController.attributes.add(data);
            } else {
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
            }
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
              editController.negotiable.value;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ElevatedButton(
                      onPressed: editing
                          ? () {
                              if (editController.infoSteps.length == editController.infoStepy.value) {
                                editController.updateListing(listing!);
                              } else {
                                editController.nextInfo();
                              }
                            }
                          : controller.images.isEmpty
                              ? attribute.required
                                  ? controller.attributes.where((element) => element["possible_attribute"] == attribute.id).isEmpty
                                      ? null
                                      : () {
                                          if (form.currentState!.validate()) {
                                            controller.nextInfo();
                                          }
                                        }
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
