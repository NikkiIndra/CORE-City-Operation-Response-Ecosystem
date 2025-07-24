import 'package:core/app/modules/notification/controllers/notification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      NotificationController.startListeningNotificationEvents();
    });
    _checkFirstTime();
  }

  void _checkFirstTime() async {
    await Future.delayed(const Duration(seconds: 2)); // simulasi loading

    bool isFirstTime = box.read('isfirsttime') ?? true;
    bool isLoggedIn = box.read('is_logged_in') ?? false;

    if (isFirstTime) {
      box.write('isfirsttime', false);
      Get.offAllNamed(Routes.ONBOARDING); // tampilkan hanya sekali
    } else {
      if (isLoggedIn) {
        Get.offAllNamed(Routes.NAVBAR); // langsung ke home jika sudah login
      } else {
        Get.offAllNamed(Routes.LOGIN); // langsung ke login jika belum login
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(child: CircularProgressIndicator(color: Color(0xFF2E382E))),
    );
  }
}
