import 'dart:async' show StreamSubscription, Timer;
import 'dart:ui';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../../data/Service/location_service.dart';
import '../../../../data/models/bus_location.dart';

class BusTrakingController extends GetxController {
  //TODO: Implement BusTrakingController
  bool initialized = false;
  final distance = 0.0.obs; // Distance traveled by the bus
  final isFullScreen = false.obs; // Fullscreen mode for the bus tracking view
  final isTracking = false.obs; // Tracking mode for the bus tracking view
  final Rx<BusLocation?> busBLocation = Rx<BusLocation?>(
    null,
  ); // Real-time Bus B
  final LocationService locationService = LocationService();
  // final ExportService exportService = ExportService();

  final RxList<Marker> markers = <Marker>[].obs;
  final RxList<LatLng> locationHistory = <LatLng>[].obs;
  final RxDouble totalDistance = 0.0.obs;
  final mapReady = false.obs;
  late final MapController mapController = MapController();
  late StreamSubscription _internetSub;

  Timer? timer;

  @override
  void onInit() {
    super.onInit();
    _internetSub = Connectivity().onConnectivityChanged.listen((result) {
      if (result == ConnectivityResult.none) {
        _showInternetDialog(Get.context!);
      }
    });
  }

  @override
  void onReady() {
    super.onReady();

    if (!initialized) {
      // Pastikan dijalankan setelah build selesai
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await initMap();
        startLocationUpdates();
        initialized = true;
      });
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    _internetSub.cancel();
    super.onClose();
  }

  void toggleFullScreen() => isFullScreen.toggle();
  void toggleTracking() => isTracking.toggle();

  Future<void> initMap() async {
    mapReady.value = false;
    await Future.delayed(Duration(seconds: 5));
    mapReady.value = true;
  }

  Marker _buildMarker(LatLng point, IconData icon, Color color) {
    return Marker(
      width: 40,
      height: 40,
      point: point,
      child: Icon(icon, color: color, size: 30),
    );
  }

  Future<void> startLocationUpdates() async {
    timer?.cancel(); // Hindari dobel timer
    timer = Timer.periodic(
      const Duration(seconds: 5),
      (_) => _updateMyLocation(),
    );
  }

  Future<void> _updateMyLocation() async {
    if (!isTracking.value) return;

    final location = await locationService.getCurrentLocation();
    if (location == null) return;

    final latLng = LatLng(location.latitude, location.longitude);

    // Update lokasi hanya untuk Bus B
    busBLocation.value = location;

    // (Opsional) Simpan histori pergerakan
    if (locationHistory.isNotEmpty) {
      final last = locationHistory.last;
      final dist = Distance().as(LengthUnit.Meter, last, latLng);
      if (dist < 10) return;
    }
    locationHistory.add(latLng);
    totalDistance.value = locationService.calculateDistance(locationHistory);
    // markers.assign(_createBusMarker(location));
    mapController.move(latLng, mapController.camera.zoom);
  }

  Marker? get realTimeBusBMarker {
    final location = busBLocation.value;
    if (location == null) return null;

    return Marker(
      width: 40.0,
      height: 40.0,
      point: LatLng(location.latitude, location.longitude),
      child: const Icon(
        CupertinoIcons.smiley,
        color: Colors.redAccent,
        size: 30,
      ),
    );
  }

  Future<void> checkInternet(BuildContext context) async {
    final connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      _showInternetDialog(context);
    }
  }

  void _showInternetDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Tidak Ada Koneksi Internet"),
            content: const Text("Silakan aktifkan koneksi internet Anda."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(ctx);
                },
                child: const Text("OKE"),
              ),
            ],
          ),
    );
  }
}
