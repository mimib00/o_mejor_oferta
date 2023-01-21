import 'package:flutter/material.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';

class VerificationTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool active;
  final Function()? onTap;
  const VerificationTile({
    super.key,
    required this.icon,
    required this.title,
    this.active = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: active ? kPrimaryColor : Colors.white,
              border: active
                  ? null
                  : Border.all(
                      color: kWhiteColor4,
                      width: 2,
                    ),
            ),
            child: Icon(
              icon,
              color: active ? Colors.white : kWhiteColor4,
              size: 30,
            ),
          ),
          const SizedBox(height: 5),
          SizedBox(
            width: 100,
            child: Text(
              title,
              style: text2,
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }
}
