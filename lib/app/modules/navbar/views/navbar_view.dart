import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/navbar_controller.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class NavbarView extends GetView<NavbarController> {
  const NavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: AnimatedSwitcher(
          reverseDuration: Duration(seconds: 1),
          duration: const Duration(seconds: 1),
          switchInCurve: Curves.linear,
          child: controller.pages[controller.currentIndex.value],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 10,
                offset: Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: GNav(
            gap: 8,
            selectedIndex: controller.currentIndex.value,
            onTabChange: controller.changeTab,
            iconSize: 24,
            curve: Curves.easeInOut,
            duration: const Duration(milliseconds: 500),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            tabBackgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
            color: Theme.of(context).iconTheme.color,
            activeColor: Colors.teal,
            tabs: const [
              GButton(icon: Icons.settings, text: 'Pengaturan'),
              GButton(icon: Icons.home, text: 'Beranda'),
              GButton(icon: Icons.person, text: 'Saya'),
            ],
          ),
        ),
      ),
    );
  }
}
