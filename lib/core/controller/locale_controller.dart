import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LocaleController extends GetxController {
  final _box = GetStorage('Locale');

  Rx<Locale?> locale = Rx(null);

  Future<void> getLocale() async {
    final data = _box.read('locale');

    if (data == null) {
      await saveLocale('es');
    } else {
      locale.value = Locale(data);
      update();
    }
  }

  Future<void> saveLocale(String code) async {
    await _box.write('locale', code);
    locale.value = Locale(code);
    Get.updateLocale(locale.value!);
    update();
  }

  @override
  void onInit() async {
    await getLocale();
    super.onInit();
  }
}
