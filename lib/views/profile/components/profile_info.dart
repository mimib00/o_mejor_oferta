import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/meta/models/user.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/loader.dart';
import 'package:unicons/unicons.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileInfoTile extends StatelessWidget {
  final User user;
  final bool showStatus;
  final bool changePhoto;
  const ProfileInfoTile({
    super.key,
    required this.user,
    this.showStatus = true,
    this.changePhoto = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Photo
        SizedBox(
          height: 80,
          width: 80,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(180),
            child: GestureDetector(
              onTap: () async {
                if (!changePhoto) return;
                final storage = FirebaseStorage.instance.ref();
                final user = Authenticator.instance.user.value!;
                final ImagePicker picker = ImagePicker();

                final photo = await picker.pickImage(source: ImageSource.gallery);
                if (photo == null) return;
                Loader.instance.showCircularProgressIndicatorWithText();
                final snapshot = await storage.child("profile/${user.id}/${user.id}").putFile(
                      File(photo.path),
                      SettableMetadata(
                        contentType: "image/jpeg",
                      ),
                    );

                if (snapshot.state == TaskState.error || snapshot.state == TaskState.canceled) {
                  throw "There was an error during upload";
                }
                if (snapshot.state == TaskState.success) {
                  var imageUrl = await snapshot.ref.getDownloadURL();
                  Get.back();
                  Authenticator.instance.updateUser({'profile_picture': imageUrl});
                }
              },
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      imageUrl: user.photo ?? "",
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) {
                        return Container(
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: kPrimaryColor,
                          ),
                          child: const Icon(
                            UniconsLine.user,
                            color: Colors.white,
                            size: 40,
                          ),
                        );
                      },
                    ),
                  ),
                  Visibility(
                    visible: changePhoto,
                    child: Positioned(
                      bottom: 0,
                      child: Container(
                        width: 80,
                        height: 30,
                        color: kWhiteColor1.withOpacity(.4),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const SizedBox(width: 20),
        // Info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              user.name,
              style: headline2,
            ),
            RatingBarIndicator(
              rating: user.rating,
              itemBuilder: (context, index) => const Icon(
                UniconsSolid.star,
                color: Colors.amber,
              ),
              itemCount: 5,
              itemSize: 20,
            ),
            showStatus
                ? Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: user.bought.toString(),
                              style: headline3.copyWith(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: " ${'bought_title'.tr}",
                              style: text1,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 20),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: user.sold.toString(),
                              style: headline3.copyWith(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: " ${'sold_title'.tr}",
                              style: text1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Visibility(
                    visible: user.facebookHandle != null,
                    child: GestureDetector(
                      onTap: () {
                        user.facebookHandle != null ? launchUrl(Uri.parse(user.facebookHandle!)) : null;
                      },
                      child: Text(
                        'Facebook profile',
                        style: text1.copyWith(color: Colors.blue),
                      ),
                    ),
                  )
          ],
        ),
      ],
    );
  }
}
