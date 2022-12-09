import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigatorController extends GetxController {
  RxInt index = 0.obs;

  Widget get screen => screens[index.value];

  List<Widget> screens = [
    Container(color: Colors.amber),
    Container(color: Colors.blue),
    Container(),
    Container(color: Colors.red),
    Container(color: Colors.green),
  ];

  void goto(int i) {
    index.value = i;
    update();
  }
}
