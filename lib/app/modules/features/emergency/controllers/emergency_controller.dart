import 'package:get/get.dart';

import '../../../../routes/app_pages.dart';

class EmergencyController extends GetxController {
  var isLoading = true.obs;
  var isSubmitting = false.obs;
  var jenisLaporan = RxnString();

  final List<String> pilihanLaporan = ['Kebakaran rumah', 'Kemalingan'];

  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(microseconds: 500), () {
      isLoading.value = false;
    });
  }

  void showMsg(String msg) {
    Get.snackbar('Pesan', msg);
  }

  void submitForm() async {
    // jika form valid dan GPS dipilih ,tampilkan pesan
    // if (formKeyDropdown.currentState!.validate() && gpsSelected.value) {
    try {
      if (jenisLaporan.value == null || jenisLaporan.value!.isEmpty) {
        showMsg('pilih jenis laporan terlebih dahulu');
        return;
      }

      Get.snackbar(
        "Sukses",
        "Data Berhasil Di kirim ke pusat",
        duration: Duration(seconds: 2),
      );
      isSubmitting.value = true;
      await Future.delayed(Duration(seconds: 2));

      await _submitData();
    } catch (e) {
      Get.snackbar("Error", "Terjadi kesalahan: $e");
    }
  }

  Future<void> _submitData() async {
    try {
      // Simulasi pengiriman data ke server
      // await api.send(...);
    } finally {
      isSubmitting.value = false;
      Get.offNamed(Routes.NAVBAR);
      Get.delete<EmergencyController>();
    }
  }
}
