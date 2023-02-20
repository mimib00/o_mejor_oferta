import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mejor_oferta/core/controller/locale_controller.dart';
import 'package:mejor_oferta/core/controller/location_controller.dart';
import 'package:mejor_oferta/core/controller/notification_controller.dart';
import 'package:mejor_oferta/core/localization/locale.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/core/theme/app_theme.dart';
import 'package:mejor_oferta/firebase_options.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await GetStorage.init("Auth");
  await GetStorage.init("Locale");
  await Get.putAsync(() async => LocaleController(), permanent: true);
  Get.put(LocationController(), permanent: true);
  Get.put(NotificationController(), permanent: true);
  Stripe.publishableKey =
      "pk_test_51Hlf3VKG6balmX6yeLDOy9jTMylr3N1FulNKOBA8cjGCsGTsPPayUit7Q5zvI4FSCDr272rPe9BixBj47kSa5xVC00JJY85JWU";
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return Obx(
          () {
            final LocaleController localeController = Get.find();
            return GetMaterialApp(
              title: 'O Mejor Oferta',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              getPages: Routes.allRoutes,
              initialRoute: Routes.splash,
              locale: localeController.locale.value,
              translations: LocalizationService(),
            );
          },
        );
      },
    );
  }
}
