import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/routes/routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    Authenticator.instance.onAuthStateChange().listen((state) async {
      if (state) {
        await Authenticator.instance.getUser();
        Get.offAllNamed(Routes.root);
      } else {
        Get.offAllNamed(Routes.login);
      }
    });
    super.onInit();
  }
}
