import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/api/authenticator.dart';
import 'package:mejor_oferta/core/config.dart';
import 'package:mejor_oferta/meta/models/packages.dart';
import 'package:mejor_oferta/meta/utils/constants.dart';
import 'package:mejor_oferta/meta/widgets/loader.dart';
import 'package:mejor_oferta/views/boost/controller/boost_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

Future<void> subscribe(int package, {int? listing}) async {
  try {
    final dio = Dio();
    final url = listing == null ? "$baseUrl/payments/create-payment-nsfw/" : "$baseUrl/payments/create-payment-boosting/";

    final token = Authenticator.instance.fetchToken();
    Loader.instance.showCircularProgressIndicatorWithText();
    final Map<String, dynamic> data = {
      "package": package,
    };
    data.addIf(listing != null, "listing", listing);

    final res = await dio.post(
      url,
      data: data,
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
      ),
    );
    Get.back();
    await Stripe.instance.presentPaymentSheet();
    await Authenticator.instance.getUser();
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

class PackageTile extends GetView<BoostController> {
  final Packages package;
  final int id;
  const PackageTile({
    super.key,
    required this.package,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kPrimaryColor),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Text(
            package.description,
            style: text3.copyWith(color: kPrimaryColor),
          ),
          const SizedBox(height: 10),
          Text(
            package.name,
            style: headline3.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "\$${package.price}",
            style: headline2.copyWith(fontWeight: FontWeight.bold, color: kPrimaryColor),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => subscribe(package.id, listing: id),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(left: 8.w, right: 8.w),
                  textStyle: headline3.copyWith(fontWeight: FontWeight.bold),
                ),
                child: Text("subscribe_btn".tr),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NsfwPackageTile extends GetView<BoostController> {
  final Packages package;

  const NsfwPackageTile({
    super.key,
    required this.package,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kPrimaryColor),
      ),
      child: Column(
        children: [
          const SizedBox(height: 30),
          Text(
            package.description,
            style: text2.copyWith(color: kPrimaryColor),
          ),
          const SizedBox(height: 8),
          Text(
            package.name,
            style: headline3.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(
            "\$${package.price}",
            style: headline2.copyWith(fontWeight: FontWeight.bold, color: kPrimaryColor),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => subscribe(package.id),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.only(left: 8.w, right: 8.w),
                  textStyle: headline3.copyWith(fontWeight: FontWeight.bold),
                ),
                child: const Text("Subscribe"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
