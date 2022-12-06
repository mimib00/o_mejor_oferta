import 'package:get/get.dart';
import 'package:mejor_oferta/views/OTP/controller/otp_controller.dart';
import 'package:mejor_oferta/views/auth/controller/login_controller.dart';
import 'package:mejor_oferta/views/auth/controller/register_controller.dart';
import 'package:mejor_oferta/views/splash/controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LoginController());
  }
}

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(RegisterController());
  }
}

class OtpBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OtpController());
  }
}
