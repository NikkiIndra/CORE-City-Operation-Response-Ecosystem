import 'package:core/app/modules/features/emergency/controllers/emergency_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ManualButton extends GetView<EmergencyController> {
  const ManualButton({super.key});

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
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Pemilik Rumah",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: height * 0.02),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Rt",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: height * 0.02),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Rw",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: height * 0.02),
                TextField(
                  maxLines: 5,
                  decoration: InputDecoration(
                    labelText: "Dusun/Blok",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: height * 0.02),
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
