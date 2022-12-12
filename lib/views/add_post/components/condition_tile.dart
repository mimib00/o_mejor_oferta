import 'package:flutter/material.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';

class ConditionTile extends StatelessWidget {
  final String title;
  final String description;
  final Function(String value)? onTap;
  final bool selected;
  const ConditionTile({
    super.key,
    required this.title,
    required this.description,
    this.selected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: kPrimaryColor5,
        borderRadius: BorderRadius.circular(10),
        border: selected ? Border.all(color: kPrimaryColor) : null,
      ),
      child: ListTile(
        onTap: () => onTap?.call(title),
        title: Text(
          title,
          style: headline3.copyWith(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          description,
          style: text2,
        ),
      ),
    );
  }
}
