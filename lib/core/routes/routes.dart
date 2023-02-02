import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/controller/app_bindings.dart';
import 'package:mejor_oferta/views/OTP/otp.dart';
import 'package:mejor_oferta/views/add_post/add_post.dart';
import 'package:mejor_oferta/views/auth/login.dart';
import 'package:mejor_oferta/views/auth/register.dart';
import 'package:mejor_oferta/views/boost/boost.dart';
import 'package:mejor_oferta/views/boost/boost_how.dart';
import 'package:mejor_oferta/views/dashboard/dashboard.dart';
import 'package:mejor_oferta/views/edit_post/edit_post.dart';
import 'package:mejor_oferta/views/forgot/forgot.dart';
import 'package:mejor_oferta/views/forgot/password_rest.dart';
import 'package:mejor_oferta/views/inbox/chat_room.dart';
import 'package:mejor_oferta/views/inbox/report.dart';
import 'package:mejor_oferta/views/leagal/policy.dart';
import 'package:mejor_oferta/views/leagal/terms.dart';
import 'package:mejor_oferta/views/notifications/notification.dart';
import 'package:mejor_oferta/views/offer/my_offers.dart';
import 'package:mejor_oferta/views/offer/offers.dart';
import 'package:mejor_oferta/views/post/post.dart';
import 'package:mejor_oferta/views/post/report.dart';
import 'package:mejor_oferta/views/profile/pages/account/account_settings.dart';
import 'package:mejor_oferta/views/profile/pages/offers/offers.dart';
import 'package:mejor_oferta/views/profile/pages/saves/saved.dart';
import 'package:mejor_oferta/views/profile/pages/transactions/bought.dart';
import 'package:mejor_oferta/views/root/root.dart';
import 'package:mejor_oferta/views/splash/splash.dart';

class Routes {
  static const root = "/";
  static const splash = "/splash";
  static const login = "/login";
  static const register = "/register";
  static const otp = "/otp";
  static const addPost = "/add_post";
  static const editPost = "/edit_post";
  static const profileAccount = "/profile/account";
  static const profileSaved = "/profile/saved";
  static const profileBought = "/profile/bought";
  static const profileOffers = "/profile/offers";
  static const post = "/post";
  static const postReport = "/post/report";
  static const offers = "/offers";
  static const myOffers = "/offers/me";
  static const inbox = "/inbox/";
  static const inboxReport = "/inbox/report";
  static const dashboard = "/dashboard";
  static const boost = "/boost";
  static const boostHow = "/boost/how";
  static const forgot = "/forgot/";
  static const changePassword = "/forgot/change";
  static const notification = "/notifications";
  static const terms = "/terms";
  static const policy = "/policy";

  static List<GetPage<dynamic>> allRoutes = [
    GetPage<Widget>(name: root, page: () => const RootScreen(), binding: NavigationBinding()),
    GetPage<Widget>(name: splash, page: () => const SplashScreen(), binding: SplashBinding()),
    GetPage<Widget>(name: login, page: () => const LoginScreen(), binding: LoginBinding()),
    GetPage<Widget>(name: register, page: () => const RegisterScreen(), binding: RegisterBinding()),
    GetPage<Widget>(name: otp, page: () => const OtpScreen(), binding: OtpBinding()),
    GetPage<Widget>(name: addPost, page: () => const AddPost(), binding: AddPostBinding()),
    GetPage<Widget>(name: editPost, page: () => const EditPost(), binding: EditPostBinding()),
    GetPage<Widget>(name: profileAccount, page: () => const AccountSettings(), binding: AccountBinding()),
    GetPage<Widget>(name: profileSaved, page: () => const SavedPosts()),
    GetPage<Widget>(name: profileBought, page: () => const BoughtItems()),
    GetPage<Widget>(name: profileOffers, page: () => const MyOfferScreen(), binding: OfferBinding()),
    GetPage<Widget>(name: post, page: () => const PostScreen(), binding: PostBinding()),
    GetPage<Widget>(name: offers, page: () => const OfferScreen(), binding: OffersBinding()),
    GetPage<Widget>(name: myOffers, page: () => const SeeOffers(), binding: OffersBinding()),
    GetPage<Widget>(name: inbox, page: () => const ChatRoom()),
    GetPage<Widget>(name: dashboard, page: () => const DashboardScreen(), binding: DashboardBinding()),
    GetPage<Widget>(name: boost, page: () => const BoosterScreen(), binding: BoostBinding()),
    GetPage<Widget>(name: boostHow, page: () => const BoostHowScreen()),
    GetPage<Widget>(name: inboxReport, page: () => const ChatReport()),
    GetPage<Widget>(name: postReport, page: () => const ListingReport()),
    GetPage<Widget>(name: forgot, page: () => ForgotPassword()),
    GetPage<Widget>(name: changePassword, page: () => PasswordReset()),
    GetPage<Widget>(name: notification, page: () => const NotificationScreen()),
    GetPage<Widget>(name: terms, page: () => const TermsScreen()),
    GetPage<Widget>(name: policy, page: () => const PolicyScreen()),
  ];
}
