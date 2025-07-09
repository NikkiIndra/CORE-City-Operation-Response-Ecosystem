import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../../data/widgets/text_rich.dart';
import '../controllers/bus_traking_controller.dart';

class BusTrakingView extends GetView<BusTrakingController> {
  BusTrakingView({super.key});
  final controller = Get.find<BusTrakingController>();
  @override
  Widget build(BuildContext context) {
    final heigh = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Obx(
        () => SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              children: [
                Expanded(
                  flex:
                      controller.isFullScreen.value
                          ? 100
                          : 1, // Adjust flex based on full screen state
                  child: Stack(
                    // Use Stack to position the floating button
                    children: [
                      FlutterMap(
                        mapController: controller.mapController,
                        options: const MapOptions(
                          initialCenter: LatLng(-6.200000, 106.816666),
                          initialZoom: 14.0,
                          maxZoom: 30.0,
                          minZoom: 15.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                          ),
                          MarkerLayer(
                            markers: [
                              if (controller.realTimeBusBMarker != null)
                                controller.realTimeBusBMarker!,
                            ],
                          ),
                        ],
                      ),

                      Positioned(
                        bottom: 10,
                        right: 10,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Card kecil (muncul saat fullscreen)
                            if (controller.isFullScreen.value)
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  clipBehavior: Clip.hardEdge,

                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 4,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 100,
                                                width: 120,
                                                child: TextRichWidget(
                                                  children: [
                                                    TextSpan(
                                                      text: "Distance: Bus A\n",
                                                    ),
                                                    TextSpan(
                                                      text: "5.2",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.black,
                                                        fontSize: 20,
                                                      ),
                                                    ),
                                                    TextSpan(
                                                      text: " km",
                                                      style: TextStyle(
                                                        fontSize: 8,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(width: 50),
                                              Container(
                                                height: 100,
                                                width: 100,
                                                child: Column(
                                                  children: [
                                                    TextRichWidget(
                                                      children: [
                                                        TextSpan(
                                                          text:
                                                              "Travel Time: 15 Mins",
                                                          style: TextStyle(
                                                            fontSize: 8,
                                                          ),
                                                        ),
                                                        TextSpan(text: "\n"),
                                                      ],
                                                    ),
                                                    Column(
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .car_rental,
                                                                  size: 20,
                                                                ),
                                                                Text(
                                                                  "18.00",
                                                                  style:
                                                                      TextStyle(
                                                                        fontSize:
                                                                            8,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(width: 5),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .car_rental,
                                                                  size: 20,
                                                                ),
                                                                Text(
                                                                  "18.00",
                                                                  style:
                                                                      TextStyle(
                                                                        fontSize:
                                                                            8,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .car_rental,
                                                                  size: 20,
                                                                ),
                                                                Text(
                                                                  "18.00",
                                                                  style:
                                                                      TextStyle(
                                                                        fontSize:
                                                                            8,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                            SizedBox(width: 5),
                                                            Row(
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .car_rental,
                                                                  size: 20,
                                                                ),
                                                                Text(
                                                                  "18.00",
                                                                  style:
                                                                      TextStyle(
                                                                        fontSize:
                                                                            8,
                                                                      ),
                                                                ),
                                                              ],
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Text("Bus 2"),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            const SizedBox(
                              width: 8,
                            ), // jarak antara card dan tombol
                            // Floating Button
                            FloatingActionButton(
                              mini: true,
                              backgroundColor: Colors.white,
                              onPressed: controller.toggleFullScreen,
                              child: Icon(
                                controller.isFullScreen.value
                                    ? Icons.fullscreen_exit
                                    : Icons.fullscreen,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                Flexible(flex: 1, child: Container.new(color: Colors.white)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
