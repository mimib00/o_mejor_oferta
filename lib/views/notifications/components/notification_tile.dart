import 'package:flutter/material.dart';
import 'package:mejor_oferta/meta/models/notification.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:timeago/timeago.dart' as timeago;

class NotificationTile extends StatelessWidget {
  final NotificationMessage notification;
  const NotificationTile({
    super.key,
    required this.notification,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: kPrimaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "O",
              style: TextStyle(color: Colors.white, fontSize: 25.sp, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                notification.title,
                style: headline3.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                notification.message,
                style: text2.copyWith(color: kWhiteColor6),
              ),
            ],
          ),
          const Spacer(),
          Text(
            timeago.format(notification.createdAt, locale: "en_short"),
            style: text2.copyWith(color: kWhiteColor6),
          ),
        ],
      ),
    );
  }
}
