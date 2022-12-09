import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/views/profile/profile.dart';

class NavigatorController extends GetxController {
  RxInt index = 0.obs;

  Widget get screen => screens[index.value];

  List<Widget> screens = [
    Container(color: Colors.amber),
    Container(color: Colors.blue),
    Container(),
    Container(color: Colors.red),
    const ProfileScreen(),
  ];

  void goto(int i) {
    index.value = i;
    update();
  }
}
