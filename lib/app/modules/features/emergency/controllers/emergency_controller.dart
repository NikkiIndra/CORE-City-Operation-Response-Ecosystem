// import 'package:get/get.dart';

// import '../../../../routes/app_pages.dart';

// class EmergencyController extends GetxController {
//   var isLoading = true.obs;
//   var isSubmitting = false.obs;
//   var jenisLaporan = RxnString();

//   final List<String> pilihanLaporan = ['Kebakaran rumah', 'Kemalingan'];

//   @override
//   void onInit() {
//     super.onInit();
//     Future.delayed(Duration(microseconds: 500), () {
//       isLoading.value = false;
//     });
//   }

//   void showMsg(String msg) {
//     Get.snackbar('Pesan', msg);
//   }

//   void submitForm() async {
//     // jika form valid dan GPS dipilih ,tampilkan pesan
//     // if (formKeyDropdown.currentState!.validate() && gpsSelected.value) {
//     try {
//       if (jenisLaporan.value == null || jenisLaporan.value!.isEmpty) {
//         showMsg('pilih jenis laporan terlebih dahulu');
//         return;
//       }

//       Get.snackbar(
//         "Sukses",
//         "Data Berhasil Di kirim ke pusat",
//         duration: Duration(seconds: 2),
//       );
//       isSubmitting.value = true;
//       await Future.delayed(Duration(seconds: 2));

//       await _submitData();
//     } catch (e) {
//       Get.snackbar("Error", "Terjadi kesalahan: $e");
//     }
//   }

//   Future<void> _submitData() async {
//     try {
//       // Simulasi pengiriman data ke server
//       // await api.send(...);
//     } finally {
//       isSubmitting.value = false;
//       Get.offNamed(Routes.NAVBAR);
//       Get.delete<EmergencyController>();
//     }
//   }
// }
// lib/controllers/report_controller.dart
import 'package:core/app/data/service/report_service.dart';
import 'package:core/app/data/models/report_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmergencyController extends GetxController {
  // Form controllers
  final nameController = TextEditingController();
  final rtController = TextEditingController();
  final rwController = TextEditingController();
  final blokController = TextEditingController();

  // Observables
  final selectedCategory = ''.obs;
  final isLoading = false.obs;

  // Constants
  static const List<String> categories = ['Kebakaran', 'Pencurian'];

  @override
  void onClose() {
    nameController.dispose();
    rtController.dispose();
    rwController.dispose();
    blokController.dispose();
    super.onClose();
  }

  Future<void> submitReport(String mode) async {
    try {
      if (!_validateInputs()) return;

      isLoading.value = true;

      final report = ReportModel(
        name: nameController.text.trim(),
        rt: rtController.text.trim(),
        rw: rwController.text.trim(),
        blok: blokController.text.trim(),
        category: selectedCategory.value,
      );

      final success = await ReportService.sendReport(report);

      if (success) {
        _showSuccess();
        _clearForm();
      } else {
        _showError('Gagal mengirim laporan');
      }
    } catch (e) {
      _showError('Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  bool _validateInputs() {
    if (selectedCategory.isEmpty) {
      _showError('Harap pilih kategori', isWarning: false);
      return false;
    }

    if (nameController.text.isEmpty ||
        rtController.text.isEmpty ||
        rwController.text.isEmpty ||
        blokController.text.isEmpty) {
      _showError('Semua field harus diisi');
      return false;
    }

    if (int.tryParse(rtController.text) == null ||
        int.tryParse(rwController.text) == null) {
      _showError('RT dan RW harus berupa angka', isWarning: true);
      return false;
    }

    return true;
  }

  void _clearForm() {
    nameController.clear();
    rtController.clear();
    rwController.clear();
    blokController.clear();
    selectedCategory.value = '';
  }

  void _showSuccess() {
    Get.snackbar(
      'Sukses',
      'Laporan berhasil dikirim',
      colorText: Colors.white,
      backgroundColor: Colors.green,
    );
  }

  void _showError(String message, {bool isWarning = false}) {
    Get.snackbar(
      isWarning ? 'Peringatan' : 'Error',
      message,
      colorText: Colors.white,
      backgroundColor: isWarning ? Colors.orange : Colors.red,
    );
  }
}
