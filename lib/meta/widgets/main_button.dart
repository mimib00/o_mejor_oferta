import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  final Function() onTap;
  final String text;
  const MainButton({
    super.key,
    required this.onTap,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: onTap,
            child: Text(text),
          ),
        ],
      ),
    );
  }
}
