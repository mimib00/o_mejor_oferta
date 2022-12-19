import 'package:flutter/material.dart';
import 'package:mejor_oferta/meta/models/attributes.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';

class AttributeTile extends StatelessWidget {
  final AttributeThumb attribute;
  const AttributeTile({
    super.key,
    required this.attribute,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          "${attribute.title}: ",
          style: text2,
        ),
        Text(
          attribute.value,
          style: headline3.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
