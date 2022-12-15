import 'package:flutter/material.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';

class CustomTextInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? labelText;
  final String? hintText;
  final bool obscure;
  final String? Function(String? value)? validator;
  final Function(String? value)? onChanged;
  final TextInputType keyboardType;
  final int? lines;
  const CustomTextInput({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.obscure = false,
    this.validator,
    this.onChanged,
    this.keyboardType = TextInputType.text,
    this.lines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: kWhiteColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xffE3E5E5), width: 1),
      ),
      child: TextFormField(
        controller: controller,
        cursorColor: kPrimaryColor,
        onChanged: (value) => onChanged?.call(value),
        maxLines: obscure ? 1 : lines,
        style: text1,
        obscureText: obscure,
        autocorrect: false,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: lines == null ? labelText : null,
          hintText: lines == null ? hintText ?? labelText : null,
        ),
      ),
    );
  }
}
