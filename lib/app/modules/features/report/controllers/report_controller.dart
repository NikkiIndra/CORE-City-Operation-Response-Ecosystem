import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../data/Service/location_service.dart';
import '../../../../routes/app_pages.dart';

class ReportController extends GetxController {
  final addressController = TextEditingController();
  final nameController = TextEditingController();
  final dateController = TextEditingController();
  final descriptionController = TextEditingController();
  var alamat = ''.obs;
  var gpsSelected = false.obs;
  var isLoadingLocation = false.obs;
  var isSubmitting = false.obs;
  var address = ''.obs;
  var images = <File>[].obs;
  final box = GetStorage();

  @override
  void onInit() {
    super.onInit();
    nameController.text = box.read('namaKtp') ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    addressController.dispose();
    nameController.dispose();
    dateController.dispose();
  }

  final _namaBulan = [
    '',
    'Januari',
    'Februari',
    'Maret',
    'April',
    'Mei',
    'Juni',
    'Juli',
    'Agustus',
    'September',
    'Oktober',
    'November',
    'Desember',
  ];
  String namaBulan(int bulan) => _namaBulan[bulan];

  final List<String> pilihanLaporan = [
    'Kebakaran',
    'Penumpukan Sampah',
    'Jalan Berlubang',
    'Butuh Duit buat jajan',
  ];
  var jenisLaporan = ''.obs;
  Future<void> getLocation() async {
    isLoadingLocation.value = true;

    try {
      // 1. Cek apakah layanan lokasi aktif
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        showMsg('Layanan lokasi belum aktif. Aktifkan GPS terlebih dahulu.');
        isLoadingLocation.value = false;
        await Geolocator.openLocationSettings(); // Buka pengaturan
        return;
      }

      // 2. Cek dan minta izin lokasi
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          showMsg('Izin lokasi ditolak');
          isLoadingLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        showMsg('Izin lokasi ditolak permanen. Aktifkan dari pengaturan.');
        isLoadingLocation.value = false;
        await Geolocator.openAppSettings();
        return;
      }

      // 3. Ambil posisi sekarang
      Position position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
      );

      // 4. Ambil alamat dari lat dan lng
      final result = await LocationService.getAddressFromLatLng(
        position.latitude,
        position.longitude,
      );

      // 5. Tampilkan alamat
      address.value = result!;
      addressController.text = result;
      gpsSelected.value = result.isNotEmpty;

      // 6. Validasi alamat
      if (result.contains('Gagal mendapatkan alamat')) {
        showMsg("Gagal mendapatkan alamat");
        gpsSelected.value = false;
      } else if (result.contains('not internet')) {
        showMsg("Internet tidak stabil atau tidak tersedia");
        gpsSelected.value = false;
      } else if (result.contains('Gagal mengakses internet')) {
        showMsg("Gagal mengakses internet");
        gpsSelected.value = false;
      } else if (result.contains('GPS')) {
        showMsg("Aktifkan GPS terlebih dahulu");
        gpsSelected.value = false;
      } else {
        gpsSelected.value = true;
      }
    } catch (e) {
      showMsg("Terjadi kesalahan saat mengambil lokasi: $e");
      gpsSelected.value = false;
    } finally {
      isLoadingLocation.value = false;
    }
  }

  void showMsg(String msg) {
    Get.snackbar('Pesan', msg);
  }

  Future<void> pickImageFromCamera() async {
    final cameraStatus = await Permission.camera.status;

    if (cameraStatus.isDenied) {
      // Jika permission sebelumnya ditolak, minta izin lagi
      final newStatus = await Permission.camera.request();
      if (!newStatus.isGranted) {
        Get.snackbar('Akses Ditolak', 'Izin kamera dibutuhkan');
        return;
      }
    } else if (cameraStatus.isPermanentlyDenied) {
      // Jika pengguna memilih "Jangan tanya lagi"
      Get.snackbar(
        'Izin Kamera Diperlukan',
        'Silakan aktifkan izin kamera di pengaturan',
      );
      openAppSettings(); // Arahkan ke setting
      return;
    }

    // Sudah diizinkan, ambil gambar
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      images.add(File(pickedFile.path));
    }
  }

  void submitForm() async {
    // jika form valid dan GPS dipilih ,tampilkan pesan
    // if (formKeyDropdown.currentState!.validate() && gpsSelected.value) {
    try {
      if (jenisLaporan.value.isEmpty) {
        showMsg('pilih jenis laporan terlebih dahulu');
        return;
      }
      if (gpsSelected.value == false) {
        showMsg('Pilih GPS terlebih dahulu');
        return;
      }
      if (addressController.text.isEmpty) {
        showMsg('Alamat belum diambil');
        return;
      }
      if (dateController.text.isEmpty) {
        showMsg('Tanggal kejadian belum diisi');
        return;
      }
      if (images.isEmpty) {
        showMsg('Ambil foto terlebih dahulu');
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
      Get.delete<ReportController>();
    }
  }

  @override
  void onClose() {
    addressController.dispose();
    nameController.dispose();
    dateController.dispose();
    super.onClose();
  }
}
