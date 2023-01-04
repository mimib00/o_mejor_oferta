import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/packages.dart';
import 'package:mejor_oferta/meta/widgets/loader.dart';

class BoostController extends GetxController {
  final dio = Dio();

  Future<List<Packages>> getPackages() async {
    try {
      const url = "$baseUrl/payments/packages/";
      final token = Authenticator.instance.fetchToken();
      final res = await dio.get(
        url,
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );

      List<Packages> packages = [];
      for (var package in res.data) {
        packages.add(Packages.fromJson(package));
      }
      return packages;
    } on DioError catch (e, stackTrace) {
      debugPrintStack(stackTrace: stackTrace);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e, stackTrace) {
      log(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      Fluttertoast.showToast(msg: e.toString());
    }
    return [];
  }

  Future<void> subscribe(int package, int listing) async {
    try {
      const url = "$baseUrl/payments/create-payment/";
      final token = Authenticator.instance.fetchToken();
      Loader.instance.showCircularProgressIndicatorWithText();
      final res = await dio.post(
        url,
        data: {
          "package": package,
          "listing": listing,
        },
        options: Options(
          headers: {
            "Authorization": "Bearer ${token["access"]}",
          },
        ),
      );
      final secret = res.data["client_secret"];
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          merchantDisplayName: 'O Mejor Offerta',
          paymentIntentClientSecret: secret,
          // applePay: const PaymentSheetApplePay(merchantCountryCode: "PR"),
          // googlePay: const PaymentSheetGooglePay(
          //   merchantCountryCode: "PR",
          //   testEnv: true,
          // ),
        ),
      );
      Get.back();
      await Stripe.instance.presentPaymentSheet();
    } on StripeException catch (e, stackTrace) {
      log(e.error.message.toString());
      if (e.error.code == FailureCode.Canceled) return;
      Get.back();
      debugPrintStack(stackTrace: stackTrace);
      log(e.error.message!);
      Fluttertoast.showToast(msg: e.error.message!);
    } on DioError catch (e, stackTrace) {
      Get.back();
      debugPrintStack(stackTrace: stackTrace);
      log(e.response!.data.toString());
      Fluttertoast.showToast(msg: e.message);
    } catch (e, stackTrace) {
      Get.back();
      log(e.toString());
      debugPrintStack(stackTrace: stackTrace);
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}
