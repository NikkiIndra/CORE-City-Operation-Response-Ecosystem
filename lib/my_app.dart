import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'app/data/Service/ThemeController.dart';
import 'app/data/bindings/global_binding.dart';
import 'app/routes/app_pages.dart';
import 'splash_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // @override
  // void initState() {
  //   NotificationController.startListeningNotificationEvents();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return GetMaterialApp(
      navigatorKey: MyApp.navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "SmartCity",
      initialBinding: GlobalBindings(),
      theme: AppThemes.lightTheme,
      darkTheme: AppThemes.darkTheme,
      themeMode: themeController.isDark ? ThemeMode.dark : ThemeMode.light,
      home:
          const SplashScreen(), // ✅ Panggil SplashScreen dulu, dia yang arahkan
      getPages: AppPages.routes,
    );
  }
}
