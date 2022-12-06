import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/routes/routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() async {
    // await Future.delayed(const Duration(seconds: 2));
    // Get.offAllNamed(Routes.login);

    Authenticator.instance.onAuthStateChange().listen((state) {
      if (state) {
        Get.offAllNamed(Routes.root);
      } else {
        Get.offAllNamed(Routes.login);
      }
    });
    super.onInit();
  }
}
