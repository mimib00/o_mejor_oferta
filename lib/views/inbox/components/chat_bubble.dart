import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/meta/models/chat.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';

class ChatBubble extends StatelessWidget {
  final Message message;
  const ChatBubble({
    super.key,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final me = Authenticator.instance.user.value!;
    final mine = me.id == message.user.id;
    return Row(
      mainAxisAlignment: mine ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Visibility(
          visible: !mine,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(180),
                child: CachedNetworkImage(
                  imageUrl: message.user.photo ?? "",
                  height: 40,
                  width: 40,
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
              const SizedBox(width: 10),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.all(15),
          margin: const EdgeInsets.symmetric(vertical: 5),
          decoration: BoxDecoration(
            color: mine ? kPrimaryColor : kWhiteColor2,
            borderRadius: BorderRadius.circular(180),
          ),
          child: Text(
            message.message,
            style: mine ? text1.copyWith(color: Colors.white) : text1,
          ),
        ),
        Visibility(
          visible: mine,
          child: Row(
            children: [
              const SizedBox(width: 10),
              ClipRRect(
                borderRadius: BorderRadius.circular(180),
                child: CachedNetworkImage(
                  imageUrl: message.user.photo ?? "",
                  height: 40,
                  width: 40,
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
            ],
          ),
        ),
      ],
    );
  }
}
