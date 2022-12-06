import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mejor_oferta/core/routes/routes.dart';
import 'package:mejor_oferta/core/theme/app_theme.dart';
import 'package:mejor_oferta/views/auth/controller/auth_controller.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Get.put(AuthController(), permanent: true);
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
          theme: AppTheme.light,
          getPages: Routes.allRoutes,
          initialRoute: Routes.splash,
        );
      },
    );
  }
}
