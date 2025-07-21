import 'package:core/app/modules/features/emergency/controllers/emergency_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HotkeysView extends GetView<EmergencyController> {
  const HotkeysView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Tombol Cepat"), centerTitle: true),
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
                      decoration: InputDecoration(
                        labelText: "Jenis Kejadian",
                        border: OutlineInputBorder(),
                      ),
                      value: controller.jenisLaporan.value,
                      items:
                          controller.pilihanLaporan.map((String jenis) {
                            return DropdownMenuItem<String>(
                              value: jenis,
                              child: Text(jenis),
                            );
                          }).toList(),
                      onChanged: (value) {
                        controller.jenisLaporan.value = value;
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
                SizedBox(height: height * 0.07),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Text(
                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
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
            child: FloatingActionButton.extended(
              onPressed:
                  controller.isSubmitting.value ? null : controller.submitForm,
              label:
                  controller.isSubmitting.value
                      ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : Text("Kirim"),
              icon: Icon(Icons.send),
              backgroundColor:
                  controller.isSubmitting.value
                      ? Colors.grey
                      : Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
