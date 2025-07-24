import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../../data/Service/ThemeController.dart';
import '../controllers/bus_traking_controller.dart';

class BusTrakingView extends GetView<BusTrakingController> {
  BusTrakingView({super.key});
  final themeC = Get.find<ThemeController>();
  final RxBool hasCheckedInternet = false.obs;

  @override
  Widget build(BuildContext context) {
    if (!hasCheckedInternet.value) {
      hasCheckedInternet.value = true;
      Future.delayed(Duration.zero, () {
        controller.checkInternet(context);
      });
    }
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Obx(
              () => Expanded(
                flex: controller.isFullScreen.value ? 100 : 1,
                child: Stack(
                  children: [
                    FlutterMap(
                      mapController: controller.mapController,
                      options: MapOptions(
                        initialCenter: LatLng(-6.886550, 107.613683),
                        initialZoom: 14.0,
                        minZoom: 10.0,
                        maxZoom: 18.0,
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://{s}.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
                          subdomains: ['a', 'b', 'c'],
                          userAgentPackageName: 'core.core',
                        ),
                        Obx(
                          () =>
                              controller.routePoints.isEmpty
                                  ? const SizedBox.shrink()
                                  : PolylineLayer(
                                    polylines: [
                                      Polyline(
                                        points: controller.routePoints,
                                        strokeWidth: 4.0,
                                        color: Colors.blue,
                                      ),
                                    ],
                                  ),
                        ),
                        Obx(
                          () => MarkerLayer(
                            markers: [
                              ...controller.busStopMarkers,
                              ...controller.busLocations.entries.map((entry) {
                                final location = entry.value;
                                final isSelected =
                                    entry.key == controller.selectedBusId.value;

                                return Marker(
                                  point: LatLng(
                                    location.latitude,
                                    location.longitude,
                                  ),
                                  width: 40,
                                  height: 40,
                                  child: GestureDetector(
                                    onTap:
                                        () => controller.selectBus(entry.key),
                                    child: Image.asset(
                                      entry.key == 'bus_1'
                                          ? 'assets/bus1.png'
                                          : 'assets/bus2.png',
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 10,
                      right: 10,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (controller.isFullScreen.value)
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color:
                                    themeC.isDark
                                        ? Colors.transparent.withOpacity(0.5)
                                        : Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 4,
                                child: SizedBox(
                                  width: width * 0.8,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 8,
                                      horizontal: 12,
                                    ),
                                    child: Obx(() {
                                      final selectedBus =
                                          controller.selectedBusId.value;
                                      if (selectedBus.isEmpty ||
                                          !controller.busLocations.containsKey(
                                            selectedBus,
                                          )) {
                                        return Text(
                                          "No bus selected",
                                          style: TextStyle(
                                            color:
                                                themeC.isDark
                                                    ? Colors.white
                                                    : Colors.black,
                                          ),
                                        );
                                      }
                                      final eta = controller.etaToNextStopFor(
                                        selectedBus,
                                      );
                                      final distance = controller
                                          .distanceToNextStopFor(selectedBus);

                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "Pilih Bus: ",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20,
                                                  color:
                                                      themeC.isDark
                                                          ? Colors.white
                                                          : Colors.black,
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      selectedBus == 'bus_1'
                                                          ? Colors.red.shade900
                                                          : Colors.grey,
                                                ),
                                                onPressed:
                                                    () => controller.selectBus(
                                                      'bus_1',
                                                    ),
                                                child: const Text(
                                                  "Bus 1",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8),
                                              ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      selectedBus == 'bus_2'
                                                          ? Colors
                                                              .yellow
                                                              .shade500
                                                          : Colors.grey,
                                                ),
                                                onPressed:
                                                    () => controller.selectBus(
                                                      'bus_2',
                                                    ),
                                                child: const Text(
                                                  "Bus 2",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Text.rich(
                                            TextSpan(
                                              text: "Selected Bus : ",
                                              style: TextStyle(
                                                // fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color:
                                                    themeC.isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                              ),
                                              children: [
                                                TextSpan(
                                                  text: selectedBus,
                                                  style: TextStyle(
                                                    color:
                                                        selectedBus == 'bus_1'
                                                            ? Colors.red
                                                            : Colors
                                                                .yellow
                                                                .shade500,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "\nDistance         : $distance",
                                                  style: TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    color:
                                                        themeC.isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                                TextSpan(
                                                  text:
                                                      "\nETA               \t\t: $eta",
                                                  style: TextStyle(
                                                    // fontWeight: FontWeight.bold,
                                                    color:
                                                        themeC.isDark
                                                            ? Colors.white
                                                            : Colors.black,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),

                          // ketika fullscreen
                          const SizedBox(width: 8),
                          controller.isFullScreen.value
                              ? FloatingActionButton(
                                mini: true,
                                backgroundColor:
                                    themeC.isDark
                                        ? Colors.transparent.withOpacity(0.5)
                                        : Colors.white,
                                onPressed: controller.toggleFullScreen,
                                child: Icon(
                                  controller.isFullScreen.value
                                      ? Icons.fullscreen_exit
                                      : Icons.fullscreen,
                                  color:
                                      themeC.isDark
                                          ? Colors.white
                                          : Colors.black,
                                ),
                              )
                              // jika nilai false maka tampilkan tombol untuk memperbesar peta
                              : Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color:
                                          themeC.isDark
                                              ? Colors.transparent.withOpacity(
                                                0.5,
                                              )
                                              : Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.2),
                                          blurRadius: 4,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: Text("Besarkan Peta"),
                                  ),

                                  // ketika dalam keadaan minimized, tampilakn icon perbesar peta
                                  FloatingActionButton(
                                    mini: true,
                                    backgroundColor:
                                        themeC.isDark
                                            ? Colors.black.withOpacity(0.5)
                                            : Colors.white,
                                    onPressed: controller.toggleFullScreen,
                                    child: Icon(
                                      controller.isFullScreen.value
                                          ? Icons.fullscreen_exit
                                          : Icons.fullscreen,
                                      color:
                                          themeC.isDark
                                              ? Colors.white
                                              : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // tampilkan ini ketika dalam keadaan full screen dan sudah klik salah satu bus
            Flexible(
              flex: 1,
              child: Obx(() {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:
                      ['bus_1', 'bus_2'].map((busId) {
                        final label = busId == 'bus_1' ? 'Bus 1' : 'Bus 2';

                        int stopIndex = controller.currentStopIndex;
                        final selected = controller.busLocations[busId];
                        if (selected != null) {
                          final busPos = LatLng(
                            selected.latitude,
                            selected.longitude,
                          );
                          for (int i = 0; i < controller.busStops.length; i++) {
                            final stop = controller.busStops[i];
                            final dist = Distance().as(
                              LengthUnit.Meter,
                              busPos,
                              stop,
                            );
                            if (dist < 30) {
                              stopIndex = i + 1;
                            }
                          }
                        }

                        return Flexible(
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color:
                                  themeC.isDark
                                      ? Colors.transparent.withOpacity(0.5)
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    color:
                                        themeC.isDark
                                            ? Colors.transparent.withOpacity(
                                              0.5,
                                            )
                                            : Colors.white,

                                    margin: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 20,
                                    ),
                                    elevation: 4,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        label,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color:
                                              themeC.isDark
                                                  ? Colors.white
                                                  : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Column(
                                  children: List.generate(controller.busStops.length, (
                                    i,
                                  ) {
                                    final isReached = i < stopIndex;
                                    final isLast =
                                        i == controller.busStops.length - 1;

                                    return Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // VERTICAL LINE & DOT SECTION
                                        Column(
                                          children: [
                                            // Lingkaran
                                            Icon(
                                              Icons.circle,
                                              size: 14,
                                              color:
                                                  isReached
                                                      ? Colors.red
                                                      : Colors.grey.shade600,
                                            ),
                                            // Garis ke bawah (jangan tambahkan jika titik terakhir)
                                            if (!isLast)
                                              Container(
                                                width: 2,
                                                height: 36,
                                                color:
                                                    isReached
                                                        ? Colors.red
                                                        : Colors.grey.shade600,
                                              ),
                                          ],
                                        ),
                                        const SizedBox(width: 8),

                                        // HALTE INFO CONTAINER
                                        Expanded(
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                              vertical: 6,
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 4,
                                            ),
                                            decoration: BoxDecoration(
                                              color:
                                                  themeC.isDark
                                                      ? Colors.transparent
                                                          .withOpacity(0.5)
                                                      : Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              border: Border.all(
                                                color:
                                                    isReached
                                                        ? Colors.red
                                                        : Colors.grey.shade400,
                                                width: 1.5,
                                              ),
                                            ),
                                            child: Text(
                                              busId == 'bus_1'
                                                  ? "Halte ${controller.busStopsName1[i]}"
                                                  : "Halte ${controller.busStopsName2[i]}",
                                              // "Halte ${controller.busStopsName1[i]}",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color:
                                                    themeC.isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                                fontWeight:
                                                    isReached
                                                        ? FontWeight.bold
                                                        : FontWeight.normal,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
