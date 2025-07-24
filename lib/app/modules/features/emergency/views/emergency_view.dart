import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/Service/ThemeController.dart';
import '../../../../data/widgets/scleton_loading.dart';
import '../controllers/emergency_controller.dart';
import 'package:core/app/modules/features/emergency/views/hotkeys.dart';

import 'manual_button.dart';

class EmergencyView extends GetView<EmergencyController> {
  EmergencyView({super.key});
  final themeC = Get.find<ThemeController>();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.isLoading.value
              ? const ScletonLoading()
              : Scaffold(
                appBar: AppBar(
                  title: const Text('Tombol Darurat'),
                  centerTitle: true,
                ),
                body: SafeArea(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Lebar dan tinggi yang fleksibel tergantung parent (bukan fixed screen)
                      final width = constraints.maxWidth;
                      final height = constraints.maxHeight;

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: height * 0.03),
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    themeC.isDark
                                        ? Theme.of(context).cardColor
                                        : Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: Colors.white,
                                  ),
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Darurat Cepat",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(width: width * 0.01),
                                      Icon(CupertinoIcons.bolt),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Text(
                                    "Fitur Laporan Akses Cepat dirancang untuk keadaan darurat atau kejadian penting yang memerlukan penyampaian informasi secara cepat ke seluruh warga melalui sistem speaker desa. Fitur ini otomatis menggunakan data pengguna yang telah terdaftar saat membuat akun—seperti nama, RT/RW, serta blok atau dusun tempat tinggal. Pengguna hanya perlu memilih jenis kejadian (misalnya: kebakaran, pencurian), lalu menekan tombol 'Kirim'. Setelah dikirim, sistem akan memproses laporan dan menyuarakannya secara otomatis. Fitur ini sangat berguna untuk mempercepat respons masyarakat dan pihak berwenang terhadap kejadian penting di lingkungan sekitar.",
                                  ),

                                  SizedBox(height: height * 0.02),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Get.to(
                                        () => HotkeysView(),
                                        transition: Transition.rightToLeft,
                                      );
                                    },
                                    label: Text("Laporkan sekarang"),
                                    icon: Icon(CupertinoIcons.play),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            Container(
                              decoration: BoxDecoration(
                                color:
                                    themeC.isDark
                                        ? Theme.of(context).cardColor
                                        : Colors.white,
                                border: Border(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: Colors.white,
                                  ),
                                ),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(12),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    offset: Offset(1, 1),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        "Tombol Manual ",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      SizedBox(width: width * 0.01),
                                      Icon(CupertinoIcons.book),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.01),
                                  Text(
                                    "Fitur Laporan Akses Manual memungkinkan warga untuk menyampaikan laporan kejadian dengan memasukkan data secara mandiri terlebih dahulu. Pengguna diminta untuk mengisi informasi seperti nama, alamat lengkap, RT/RW, dan blok atau dusun sebelum memilih kategori kejadian dan mengirim laporan. Ini cocok digunakan bagi warga tamu, perangkat desa, atau akun yang tidak memiliki data pribadi tersimpan dalam sistem. Meskipun membutuhkan sedikit waktu lebih lama, fitur ini tetap efektif dalam menyampaikan informasi penting melalui speaker desa setelah laporan dikirim.",
                                  ),
                                  SizedBox(height: height * 0.02),
                                  ElevatedButton.icon(
                                    onPressed: () {
                                      Get.to(
                                        () => ManualButton(),
                                        transition: Transition.rightToLeft,
                                      );
                                    },
                                    label: Text("Laporkan sekarang"),
                                    icon: Icon(CupertinoIcons.play),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
    );
  }
}
