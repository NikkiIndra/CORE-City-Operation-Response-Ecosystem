import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:core/app/modules/features/emergency/controllers/emergency_controller.dart';

import '../../../../data/Service/ThemeController.dart';

class HotkeysView extends GetView<EmergencyController> {
  HotkeysView({super.key});
  final themeC = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("Tombol Cepat"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
        child: SingleChildScrollView(
          child: InteractiveViewer(
            minScale: 0.3,
            maxScale: 5.0,
            child: Column(
              children: [
                SizedBox(height: height * 0.03),
                Form(
                  child: Obx(
                    () => DropdownButtonFormField<String>(
                      decoration: const InputDecoration(
                        labelText: "Jenis Kejadian",
                        border: OutlineInputBorder(),
                      ),
                      value:
                          controller.selectedCategory.value.isEmpty
                              ? null
                              : controller.selectedCategory.value,
                      items:
                          EmergencyController.categories.map((String jenis) {
                            return DropdownMenuItem<String>(
                              value: jenis,
                              child: Text(jenis),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          controller.selectedCategory.value = value;
                        }
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Pilih jenis laporan';
                        }
                        return null;
                      },
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Text.rich(
                    TextSpan(
                      text: "Perhatian 🚨\n",
                      style: const TextStyle(fontSize: 20, color: Colors.red),
                      children: [
                        TextSpan(
                          text:
                              "Gunakan fitur Laporan Cepat hanya dalam situasi penting dan nyata...",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Obx(
        () => Padding(
          padding: const EdgeInsets.only(bottom: 30),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.94,
            height: 50,
            child:
                controller.isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : FloatingActionButton.extended(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(
                          color: themeC.isDark ? Colors.white : Colors.black,
                        ),
                      ),
                      backgroundColor:
                          themeC.isDark
                              ? Colors.transparent.withOpacity(0.5)
                              : Colors.white,

                      onPressed:
                          controller.isLoading.value
                              ? null
                              : () => controller.submitReport("quick"),
                      label:
                          controller.isLoading.value
                              ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                              : const Text("Kirim Laporan"),
                    ),
          ),
        ),
      ),
    );
  }
}
