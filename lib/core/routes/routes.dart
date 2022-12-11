import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/controller/app_bindings.dart';
import 'package:mejor_oferta/views/OTP/otp.dart';
import 'package:mejor_oferta/views/add_post/add_post.dart';
import 'package:mejor_oferta/views/auth/login.dart';
import 'package:mejor_oferta/views/auth/register.dart';
import 'package:mejor_oferta/views/root/root.dart';
import 'package:mejor_oferta/views/splash/splash.dart';

class Routes {
  static const root = "/";
  static const splash = "/splash";
  static const login = "/login";
  static const register = "/register";
  static const otp = "/otp";
  static const addPost = "/add_post";

  static List<GetPage<dynamic>> allRoutes = [
    GetPage<Widget>(name: root, page: () => const RootScreen(), binding: NavigationBinding()),
    GetPage<Widget>(name: splash, page: () => const SplashScreen(), binding: SplashBinding()),
    GetPage<Widget>(name: login, page: () => const LoginScreen(), binding: LoginBinding()),
    GetPage<Widget>(name: register, page: () => const RegisterScreen(), binding: RegisterBinding()),
    GetPage<Widget>(name: otp, page: () => const OtpScreen(), binding: OtpBinding()),
    GetPage<Widget>(name: addPost, page: () => const AddPost(), binding: AddPostBinding()),
  ];
}
