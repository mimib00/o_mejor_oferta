import 'package:get/get.dart';
import 'package:mejor_oferta/views/OTP/controller/otp_controller.dart';
import 'package:mejor_oferta/views/add_post/controller/add_post_controller.dart';
import 'package:mejor_oferta/views/auth/controller/login_controller.dart';
import 'package:mejor_oferta/views/auth/controller/register_controller.dart';
import 'package:mejor_oferta/views/dashboard/controller/dashboard_controller.dart';
import 'package:mejor_oferta/views/home/controller/home_controller.dart';
import 'package:mejor_oferta/views/inbox/controller/chat_controller.dart';
import 'package:mejor_oferta/views/offer/controller/offers_controller.dart';
import 'package:mejor_oferta/views/post/controller/post_controller.dart';
import 'package:mejor_oferta/views/profile/controller/account_controller.dart';
import 'package:mejor_oferta/views/profile/controller/profile_controller.dart';
import 'package:mejor_oferta/views/root/controller/navigator_controller.dart';
import 'package:mejor_oferta/views/selling/controller/selling_controller.dart';
import 'package:mejor_oferta/views/splash/controller/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SplashController());
  }
}

class NavigationBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NavigatorController());
    Get.lazyPut(() => ProfileController());
    Get.lazyPut(() => HomeController());
    Get.lazyPut(() => ChatController(), fenix: true);
    Get.lazyPut(() => SellingController());
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

class AddPostBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddPostController());
  }
}

class AccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AccountController());
  }
}

class PostBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(PostController());
  }
}

class OffersBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(OffersController());
  }
}

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
  }
}
