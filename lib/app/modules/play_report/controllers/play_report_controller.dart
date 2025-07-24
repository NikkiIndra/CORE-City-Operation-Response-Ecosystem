// lib/controllers/report_controller.dart
import 'package:core/app/data/Service/report_service.dart';
import 'package:core/app/data/models/report_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayReportController extends GetxController {
  final nameController = TextEditingController();
  final rtController = TextEditingController();
  final rwController = TextEditingController();
  final blokController = TextEditingController();

  var selectedCategory = ''.obs;
  var isLoading = false.obs;

  final List<String> categories = [
    'Kebakaran',
    'Pencurian',
    'Kebanjir',
    'Kecelakaan',
  ];

  void submitReport(String mode) async {
    final name = nameController.text;
    final rt = rtController.text;
    final rw = rwController.text;
    final blok = blokController.text;

    if (name.isEmpty || rt.isEmpty || rw.isEmpty || blok.isEmpty) {
      Get.snackbar('Error', 'Semua field harus diisi');
      return;
    }

    if (int.tryParse(rt) == null || int.tryParse(rw) == null) {
      Get.snackbar('Validasi', 'RT dan RW harus berupa angka');
      return;
    }

    isLoading.value = true;

    final report = ReportModel(
      name: name,
      rt: rt,
      rw: rw,
      blok: blok,
      category: selectedCategory.value,
    );

    final success = await ReportService.sendReport(report);

    isLoading.value = false;

    if (success) {
      Get.snackbar('Sukses', 'Laporan berhasil dikirim');
    } else {
      Get.snackbar('Gagal', 'Gagal mengirim laporan');
    }
  }
}
