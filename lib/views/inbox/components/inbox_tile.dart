import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/meta/models/chat.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';

class InboxTile extends StatelessWidget {
  final InboxThread thread;
  const InboxTile({
    super.key,
    required this.thread,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => Get.toNamed(Routes.inbox,
          parameters: {"id": thread.id.toString(), "name": thread.user.name, "uid": thread.user.id.toString()}),
      dense: true,
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(180),
        child: CachedNetworkImage(
          imageUrl: thread.user.photo ?? "",
          height: 50,
          width: 50,
          fit: BoxFit.cover,
          errorWidget: (context, url, error) {
            return Container(
              alignment: Alignment.center,
              color: kPrimaryColor,
              child: const Icon(
                Icons.person_rounded,
                color: Colors.white,
              ),
            );
          },
        ),
      ),
      title: Text(
        thread.user.name,
        style: text1,
      ),
      subtitle: Text(
        thread.message,
        style: text2.copyWith(color: kWhiteColor6),
      ),
      trailing: Text(
        DateFormat("hh:mm a").format(thread.lastMessage ?? thread.updated),
        style: text2.copyWith(color: kWhiteColor6),
      ),
    );
  }
}
