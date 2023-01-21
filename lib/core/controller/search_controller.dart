import 'package:get/get.dart';
import 'package:mejor_oferta/meta/models/category.dart';
import 'package:mejor_oferta/meta/models/chat.dart';
import 'package:mejor_oferta/meta/models/state.dart';

class SearchController extends GetxController {
  RxList<States> locations = <States>[].obs;
  RxList<FullCategory> categories = <FullCategory>[].obs;
  RxList<InboxThread> threads = <InboxThread>[].obs;

  RxString locatioQuery = "".obs;
  RxString categoryQuery = "".obs;
  RxString threadQuery = "".obs;

  List<States> locs = [];
  List<FullCategory> cats = [];
  List<InboxThread> thread = [];

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

    update();
  }

  void searchInbox() {
    threads.value =
        thread.where((element) => element.user.name.contains(RegExp(threadQuery.value, caseSensitive: false))).toList();

    update();
  }

  @override
  void onInit() {
    debounce(locatioQuery, (callback) => searchLocation(), time: const Duration(milliseconds: 500));
    debounce(categoryQuery, (callback) => searchCategory(), time: const Duration(milliseconds: 500));
    debounce(threadQuery, (callback) => searchInbox(), time: const Duration(milliseconds: 500));
    super.onInit();
  }
}
