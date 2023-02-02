import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/views/home/home.dart';
import 'package:mejor_oferta/views/inbox/chatrooms.dart';
import 'package:mejor_oferta/views/profile/profile.dart';
import 'package:mejor_oferta/views/selling/selling.dart';

class NavigatorController extends GetxController {
  RxInt index = 0.obs;

  Widget get screen => screens[index.value];

  List<Widget> screens = [
    const HomeScreen(),
    const Inbox(),
    Container(),
    const SellingScreen(),
    ProfileScreen(),
  ];

  void goto(int i) {
    index.value = i;
    update();
  }
}
