import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../data/widgets/scleton_loading.dart';
import '../controllers/emergency_controller.dart';

class EmergencyView extends GetView<EmergencyController> {
  const EmergencyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () =>
          controller.isLoading.value
              ? const ScletonLoading()
              : Scaffold(
                appBar: AppBar(
                  title: const Text('EmergencyView'),
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
                                color: Colors.white,
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
                                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",
                                  ),

                                  SizedBox(height: height * 0.02),
                                  ElevatedButton.icon(
                                    onPressed: () {},
                                    label: Text("Laporkan sekarang"),
                                    icon: Icon(CupertinoIcons.play),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                        "Darurat Manual ",
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
                                    "Lorem Ipsum is simply dummy text of the printing and typesetting industry.  when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Lorem Ipsum has been the industry's standard dummy text ever since the 1500s,",
                                  ),
                                  SizedBox(height: height * 0.02),
                                  ElevatedButton.icon(
                                    onPressed: () {},
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
