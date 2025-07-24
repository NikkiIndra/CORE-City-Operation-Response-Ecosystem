import 'package:core/app/modules/features/emergency/controllers/emergency_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/Service/ThemeController.dart';

class ManualButton extends GetView<EmergencyController> {
  ManualButton({super.key});
  final themeC = Get.find<ThemeController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Darurat Manual')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInput(controller.nameController, 'Nama'),
                _buildInput(
                  controller.rtController,
                  'RT (angka)',
                  inputType: TextInputType.number,
                ),
                _buildInput(
                  controller.rwController,
                  'RW (angka)',
                  inputType: TextInputType.number,
                ),
                _buildInput(controller.blokController, 'Blok'),
                const SizedBox(height: 5),
                const Text(
                  'Kategori',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                _buildCategoryDropdown(),
                const SizedBox(height: 8),
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
                              "Gunakan fitur Laporan Cepat hanya dalam situasi penting dan nyata, karena laporan akan langsung diumumkan ke seluruh warga tanpa verifikasi ulang. Anda hanya perlu memilih kategori kejadian dan menekan 'Kirim'—data pelapor seperti nama dan alamat akan langsung tercantum otomatis. Mohon jangan gunakan fitur ini untuk iseng, laporan palsu, atau bercanda. Penggunaan yang tidak sesuai akan dicatat dan dikenakan sanksi tegas dari pihak desa, termasuk denda administratif sesuai peraturan yang berlaku. Laporkan hanya jika benar-benar diperlukan!",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                // _buildSubmitButton(),
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

  Widget _buildInput(
    TextEditingController c,
    String label, {
    TextInputType inputType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: c,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryDropdown() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(4),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value:
              controller.selectedCategory.value.isEmpty
                  ? null
                  : controller.selectedCategory.value,
          hint: const Text('Pilih Kategori'),
          onChanged: (value) => controller.selectedCategory.value = value!,
          items:
              EmergencyController.categories
                  .map(
                    (e) => DropdownMenuItem(
                      value: e,
                      child: Text(e, overflow: TextOverflow.ellipsis),
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child:
          controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : ElevatedButton(
                onPressed: () {
                  if (controller.selectedCategory.value.isEmpty) {
                    Get.snackbar('Error', 'Harap pilih kategori');
                    return;
                  }
                  controller.submitReport("manual");
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Kirim Laporan'),
              ),
    );
  }
}
