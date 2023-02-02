import 'package:flutter/material.dart';
import 'package:mejor_oferta/meta/models/attributes.dart';
import 'package:mejor_oferta/meta/models/listing.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/views/add_post/components/attribute_input.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AttributesStep extends StatelessWidget {
  final Attributes attribute;
  final bool editing;
  final Listing? listing;
  const AttributesStep({
    super.key,
    required this.attribute,
    this.editing = false,
    this.listing,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 3.w, right: 3.w, top: 3.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            attribute.title,
            style: headline3,
          ),
          const SizedBox(height: 5),
          Text(
            attribute.description,
            style: text2,
          ),
          const SizedBox(height: 20),
          AttributeInput(
            attribute: attribute,
            editing: editing,
            listing: listing,
          )
        ],
      ),
    );
  }
}
