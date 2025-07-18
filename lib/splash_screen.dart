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
    _checkFirstTime();
  }

  void _checkFirstTime() async {
    await Future.delayed(const Duration(seconds: 2)); // simulasi loading
    bool isFirstTime = box.read('isfirsttime') ?? true;
    bool isLoggedIn = box.read('is_logged_in') ?? false;

    if (isFirstTime) {
      box.write('isfirsttime', false);
      Get.offAllNamed(Routes.ONBOARDING); // arahkan ke onboarding
    } else {
      if (isLoggedIn) {
        Get.offAllNamed(Routes.NAVBAR); // arahkan ke navbar
      } else {
        Get.offAllNamed(
          Routes.ONBOARDING,
        ); // arahkan ke login harusnya ke register untuk percobaan langsung ke home aja
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
