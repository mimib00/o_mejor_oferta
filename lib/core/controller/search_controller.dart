import 'package:get/get.dart';
import 'package:mejor_oferta/meta/models/category.dart';
import 'package:mejor_oferta/meta/models/state.dart';

class SearchController extends GetxController {
  RxList<States> locations = <States>[].obs;
  RxList<FullCategory> categories = <FullCategory>[].obs;

  RxString locatioQuery = "".obs;
  RxString categoryQuery = "".obs;

  List<States> locs = [];
  List<FullCategory> cats = [];

  void searchLocation() {
    locations.value =
        locs.where((element) => element.name.contains(RegExp(locatioQuery.value, caseSensitive: false))).toList();
    update();
  }

  void searchCategory() {
    categories.value = cats
        .where((element) => element.children
            .where((element) => element.name.contains(RegExp(categoryQuery.value, caseSensitive: false)))
            .isNotEmpty)
        .toList();
    // cats.where((element) => element.children.contains(RegExp(categoryQuery.value, caseSensitive: false))).toList();
    update();
  }

  @override
  void onInit() {
    debounce(locatioQuery, (callback) => searchLocation(), time: const Duration(milliseconds: 500));
    debounce(categoryQuery, (callback) => searchCategory(), time: const Duration(milliseconds: 500));
    super.onInit();
  }
}
