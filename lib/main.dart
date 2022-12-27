import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mejor_oferta/core/controller/location_controller.dart';
import 'package:mejor_oferta/core/controller/notification_controller.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/core/theme/app_theme.dart';
import 'package:mejor_oferta/firebase_options.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await GetStorage.init("Auth");
  Get.put(LocationController(), permanent: true);
  Get.put(NotificationController(), permanent: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orientation, deviceType) {
        return GetMaterialApp(
          title: 'O Mejor Oferta',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          getPages: Routes.allRoutes,
          initialRoute: Routes.splash,
        );
      },
    );
  }
}
