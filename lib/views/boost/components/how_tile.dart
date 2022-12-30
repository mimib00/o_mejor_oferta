import 'package:flutter/material.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';

class HowTile extends StatelessWidget {
  final String image;
  final String title;
  final String info;
  const HowTile({
    super.key,
    required this.image,
    required this.title,
    required this.info,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Image.asset(
            image,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: headline3.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  info,
                  style: text1.copyWith(color: kWhiteColor6),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
