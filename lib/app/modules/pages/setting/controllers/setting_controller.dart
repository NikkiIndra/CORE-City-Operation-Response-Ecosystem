import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../views/modern_calendar.dart';

class SettingController extends GetxController {
  var cameraAllowed = false.obs;
  var locationAllowed = false.obs;
  var selectedDate = Rxn<DateTime>();
  var notificationAllowed = false.obs;

  void showCalendarPicker(BuildContext context) {
    Get.to(() => const ModernCalendar(), transition: Transition.cupertino);
  }

  @override
  void onInit() {
    checkPermissions();
    super.onInit();
  }

  void checkPermissions() async {
    final allowed = await AwesomeNotifications().isNotificationAllowed();
    notificationAllowed.value = allowed;

    if (!allowed) {
      // opsi: tunjukkan dialog/pesan bahwa user perlu buka settings manual
      print('Notifikasi diblokir, arahkan ke Settings.');
    }

    cameraAllowed.value = await Permission.camera.isGranted;
    locationAllowed.value = await Permission.location.isGranted;

    cameraAllowed.value = await Permission.camera.isGranted;
    locationAllowed.value = await Permission.location.isGranted;
  }

  void openSettingsAndRefresh() async {
    await openAppSettings();
    Future.delayed(const Duration(seconds: 1), () => checkPermissions());
  }
}
