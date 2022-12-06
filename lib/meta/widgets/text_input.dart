import 'package:flutter/material.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';

class TextInput extends StatelessWidget {
  final TextEditingController controller;
  final String? labelText;
  final String? hintText;
  final bool obscure;
  const TextInput({
    super.key,
    required this.controller,
    this.hintText,
    this.labelText,
    this.obscure = false,
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
        cursorColor: kPrimaryColor,
        style: text1,
        obscureText: obscure,
        autocorrect: false,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText ?? labelText,
        ),
      ),
    );
  }
}
