import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../notification/controllers/notification_controller.dart';
import '../controllers/report_controller.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ReportView extends GetView<ReportController> {
  const ReportView({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: Text("Lapor Kejadian"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, bottom: 12),
        child: SingleChildScrollView(
          child: InteractiveViewer(
            minScale: 0.3,
            maxScale: 5.0,
            child: Column(
              children: [
                Form(
                  child: Column(
                    children: [
                      Obx(
                        () => DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: "Jenis Laporan",
                            border: OutlineInputBorder(),
                          ),
                          value:
                              controller.jenisLaporan.value == ''
                                  ? null
                                  : controller.jenisLaporan.value,
                          items:
                              controller.pilihanLaporan.map((String jenis) {
                                return DropdownMenuItem<String>(
                                  value: jenis,
                                  child: Text(jenis),
                                );
                              }).toList(),
                          onChanged: (value) {
                            if (value != null) {
                              controller.jenisLaporan.value = value;
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
                      SizedBox(height: height * 0.012),
                      TextFormField(
                        controller: controller.nameController,
                        decoration: InputDecoration(
                          enabled: false,
                          labelText: "nama",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      SizedBox(height: height * 0.012),
                      Row(
                        children: [
                          Expanded(
                            flex: 6,
                            child: TextField(
                              controller: controller.addressController,
                              readOnly: true,
                              showCursor: false,
                              onTap: () {
                                if (controller.gpsSelected.value) {
                                  controller.showMsg(
                                    'Klik tombol Gps untuk mendapatkan alamat',
                                  );
                                }
                              },
                              decoration: InputDecoration(
                                labelText: 'Alamat',
                                prefixIcon: Icon(Icons.location_on),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: width * 0.008),
                          Expanded(
                            flex: 2,
                            child: Obx(
                              () => ElevatedButton.icon(
                                onPressed:
                                    controller.isLoadingLocation.value
                                        ? null
                                        : controller.getLocation,
                                icon: Icon(Icons.location_on),
                                label:
                                    controller.isLoadingLocation.value
                                        ? LoadingAnimationWidget.staggeredDotsWave(
                                          color: Colors.white,
                                          size: 20,
                                        )
                                        : FittedBox(
                                          child: Text(
                                            "Gps",
                                            style: TextStyle(fontSize: 17),
                                          ),
                                        ),
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 14),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: height * 0.012),
                      TextFormField(
                        controller: controller.dateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "Tanggal Kejadian",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(Icons.date_range),
                            onPressed: () async {
                              DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                controller.dateController.text =
                                    "${picked.day} ${controller.namaBulan(picked.month)} ${picked.year}";
                              }
                            },
                          ),
                        ),
                        onTap: () {
                          final today = DateTime.now();
                          controller.dateController.text =
                              "${today.day} ${controller.namaBulan(today.month)} ${today.year}";
                        },
                      ),
                      SizedBox(height: height * 0.012),
                      TextFormField(
                        controller: controller.descriptionController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          labelText: "Deskripsi Kejadian",
                          hintText:
                              'Tulis kronologi atau detail laporan di sini...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 1,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: height * 0.012),
                      GestureDetector(
                        onTap: controller.pickImageFromCamera,
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Obx(
                            () => Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                ...controller.images.map(
                                  (file) => ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.file(
                                      file,
                                      width: width * 0.42,
                                      height: height * 0.2,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: controller.pickImageFromCamera,
                                  child: Container(
                                    width: width * 0.42,
                                    height: height * 0.2,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                      color: Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.3),
                                      border: Border.all(color: Colors.black),
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Icon(
                                          Icons.add_a_photo_rounded,
                                          size: 36,
                                        ),
                                        SizedBox(height: 8),
                                        Text("Tambah Foto"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 80,
                      ), // Jarak agar konten tidak tertutup FAB
                    ],
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
                  controller.isSubmitting.value
                      ? null
                      : () async {
                        controller.submitForm(); // Kirim form dulu
                        NotificationController.createNewNotification(
                          "laporan Terkirim",
                          "Laporan Anda berhasil dikirim. Terima kasih!",
                          bigPicture: "assets/slide_1.png",
                        ); // Tampilkan notifikasi setelah sukses
                      },
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
