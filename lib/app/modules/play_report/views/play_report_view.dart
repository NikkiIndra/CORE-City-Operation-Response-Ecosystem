// lib/screens/report_input_screen.dart
import 'package:core/app/modules/play_report/controllers/play_report_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PlayReportView extends GetView<PlayReportController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Form Laporan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(
          () => Column(
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
              const SizedBox(height: 10),
              const Text('Kategori'),
              DropdownButton<String>(
                value: controller.selectedCategory.value,
                onChanged:
                    (value) => controller.selectedCategory.value = value!,
                items:
                    controller.categories
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
              ),
              const Spacer(),
              controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                    onPressed: () => controller.submitReport("manual"),
                    child: const Text('Kirim Laporan'),
                  ),
            ],
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
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: inputType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
