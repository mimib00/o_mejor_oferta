import 'package:flutter/material.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';

class CustomTextInput extends StatefulWidget {
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
  State<CustomTextInput> createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  late bool show;
  @override
  void initState() {
    show = !widget.obscure;
    super.initState();
  }

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
        controller: widget.controller,
        cursorColor: kPrimaryColor,
        onChanged: (value) => widget.onChanged?.call(value),
        maxLines: !show ? 1 : widget.lines,
        style: text1,
        obscureText: !show,
        autocorrect: false,
        validator: widget.validator,
        keyboardType: widget.keyboardType,
        decoration: InputDecoration(
          labelText: widget.lines == null ? widget.labelText : null,
          hintText: widget.lines == null ? widget.hintText ?? widget.labelText : null,
          suffixIcon: Visibility(
            visible: widget.obscure,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  show = !show;
                });
              },
              child: Icon(show ? Icons.visibility_off : Icons.visibility),
            ),
          ),
        ),
      ),
    );
  }
}
