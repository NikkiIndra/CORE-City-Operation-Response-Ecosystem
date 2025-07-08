import 'package:core/app/modules/pages/home/views/home_view.dart';
import 'package:core/app/modules/pages/profile/views/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../pages/setting/views/setting_view.dart';

class NavbarController extends GetxController {
  final RxInt currentIndex = 1.obs;

  // Membuat halaman dinamis berdasarkan indeks
  List<Widget> get pages => [SettingView(), HomeView(), ProfileView()];

  // List<String> get titles => ['Home', 'Profile', 'Settings'];
  
  // Method untuk mengubah tab
  void changeTab(int index) {
    currentIndex.value = index;
  }
}
