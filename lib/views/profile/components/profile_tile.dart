import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final Function()? onTap;
  const ProfileTile({super.key, required this.icon, required this.title, this.trailing, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      horizontalTitleGap: 0,
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        icon,
        color: kWhiteColor5,
      ),
      title: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 15.sp,
          fontWeight: FontWeight.w400,
          color: kWhiteColor5,
        ),
      ),
      trailing: trailing ??
          const Icon(
            Icons.arrow_forward_ios_rounded,
            color: kWhiteColor5,
          ),
    );
  }
}
