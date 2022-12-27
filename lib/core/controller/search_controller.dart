import 'package:get/get.dart';
import 'package:mejor_oferta/meta/models/state.dart';

class SearchController extends GetxController {
  RxList<States> locations = <States>[].obs;

  RxString locatioQuery = "".obs;

  List<States> locs = [];

  void searchLocation() {
    locations.value =
        locs.where((element) => element.name.contains(RegExp(locatioQuery.value, caseSensitive: false))).toList();
    update();
  }

  @override
  void onInit() {
    debounce(locatioQuery, (callback) => searchLocation(), time: const Duration(milliseconds: 500));
    super.onInit();
  }
}
