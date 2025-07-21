import 'dart:async';
import 'dart:convert';

import 'package:app_settings/app_settings.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;

import '../../../../data/models/bus_location.dart';

class BusTrakingController extends GetxController {
  final RxMap<String, BusLocation> busLocations = <String, BusLocation>{}.obs;
  final RxString selectedBusId = ''.obs;
  final isFullScreen = false.obs;
  final isLoading = false.obs;

  final RxList<Marker> markers = <Marker>[].obs;

  late final MapController mapController = MapController();
  late StreamSubscription _internetSub;
  Timer? timer;

  final RxList<LatLng> routePoints = <LatLng>[].obs;
  final List<String> busStopsName = ['alun-alun STIKOM', 'Pemuda', 'Move-Gym'];

  void selectBus(String busId) {
    selectedBusId.value = busId;

    final selected = busLocations[busId];
    if (selected != null) {
      final latLng = LatLng(selected.latitude, selected.longitude);
      final zoom = getRecommendedZoom(latLng);
      mapController.move(latLng, zoom);
      generateRoutePolyline();
      checkNextStopArrival(latLng);
    }
  }

  List<Marker> get busStopMarkers =>
      busStops.map((pos) {
        return Marker(
          width: 30,
          height: 30,
          point: pos,
          child: Icon(
            Icons.location_on,
            color: Colors.deepPurple.shade900,
            size: 25,
          ),
        );
      }).toList();

  final List<LatLng> busStops = [
    LatLng(-6.712512, 108.531385),
    LatLng(-6.730743, 108.540145),
    LatLng(-6.739317, 108.543153),
  ];

  int currentStopIndex = 0;

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
    timer = Timer.periodic(const Duration(seconds: 5), (_) {
      fetchLocationFromThingSpeak();
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    _internetSub.cancel();
    super.onClose();
  }

  void toggleFullScreen() => isFullScreen.toggle();

  List<Marker> get allBusMarkers {
    return busLocations.entries.map((entry) {
      final color = entry.key == 'bus_1' ? Colors.green : Colors.red;
      return Marker(
        width: 40,
        height: 40,
        point: LatLng(entry.value.latitude, entry.value.longitude),
        child: Icon(CupertinoIcons.bus, color: color, size: 30),
      );
    }).toList();
  }

  Future<void> fetchLocationFromThingSpeak() async {
    try {
      final responses = await Future.wait([
        http.get(
          Uri.parse(
            'https://api.thingspeak.com/channels/2965388/feeds/last.json?api_key=KRBIG8BM8GML5H1P',
          ),
        ),
        http.get(
          Uri.parse(
            'https://api.thingspeak.com/channels/3007043/feeds/last.json?api_key=Q6U4HLWNFQA5VUZI',
          ),
        ),
      ]);

      if (responses[0].statusCode == 200) {
        final data1 = json.decode(responses[0].body);
        final latitude1 = double.parse(data1['field1']);
        final longitude1 = double.parse(data1['field2']);

        busLocations['bus_1'] = BusLocation(
          id: 'bus_1',
          latitude: latitude1,
          longitude: longitude1,
        );
      }

      if (responses[1].statusCode == 200) {
        final data2 = json.decode(responses[1].body);
        final latitude2 = double.parse(data2['field1']);
        final longitude2 = double.parse(data2['field2']);

        busLocations['bus_2'] = BusLocation(
          id: 'bus_2',
          latitude: latitude2,
          longitude: longitude2,
        );
      }

      final selectedBus = busLocations[selectedBusId.value];
      if (selectedBus != null) {
        final latLng = LatLng(selectedBus.latitude, selectedBus.longitude);
        final zoom = getRecommendedZoom(latLng);
        mapController.move(latLng, zoom);
        generateRoutePolyline();
        checkNextStopArrival(latLng);
      }
    } catch (e) {
      print('Error fetching data from ThingSpeak: $e');
    }
  }

  void checkNextStopArrival(LatLng currentBusPos) {
    if (currentStopIndex >= busStops.length) return;

    final targetStop = busStops[currentStopIndex];
    final distance = Distance().as(LengthUnit.Meter, currentBusPos, targetStop);
    if (distance < 30) {
      currentStopIndex++;
    }
  }

  String distanceToNextStopFor(String busId) {
    final bus = busLocations[busId];
    if (bus == null || currentStopIndex >= busStops.length) return "-";

    final pos = LatLng(bus.latitude, bus.longitude);
    final nextStop = busStops[currentStopIndex];
    final distance = Distance().as(LengthUnit.Kilometer, pos, nextStop);
    return "${distance.toStringAsFixed(2)} km";
  }

  String etaToNextStopFor(String busId) {
    final bus = busLocations[busId];
    if (bus == null || currentStopIndex >= busStops.length) return "-";

    final pos = LatLng(bus.latitude, bus.longitude);
    final nextStop = busStops[currentStopIndex];
    final dist = Distance().as(LengthUnit.Kilometer, pos, nextStop);

    final timeMinutes = (dist / 30 * 60).round();
    return "$timeMinutes min";
  }

  String get distanceToNextStop {
    final bus = busLocations[selectedBusId.value];
    if (bus == null || currentStopIndex >= busStops.length) return "-";

    final busPos = LatLng(bus.latitude, bus.longitude);
    final nextStop = busStops[currentStopIndex];
    final distance = Distance().as(LengthUnit.Kilometer, busPos, nextStop);
    return "${distance.toStringAsFixed(2)} km";
  }

  String get etaToNextStop {
    final bus = busLocations[selectedBusId.value];
    if (bus == null || currentStopIndex >= busStops.length) return "-";

    final busPos = LatLng(bus.latitude, bus.longitude);
    final nextStop = busStops[currentStopIndex];
    final distanceInKm = Distance().as(LengthUnit.Kilometer, busPos, nextStop);

    final speedKmh = 30;
    final timeInHours = distanceInKm / speedKmh;
    final timeInMinutes = (timeInHours * 60).round();

    return "$timeInMinutes min";
  }

  Marker? get realTimeBusBMarker {
    final location = busLocations[selectedBusId.value];
    if (location == null) return null;

    return Marker(
      width: 40.0,
      height: 40.0,
      point: LatLng(location.latitude, location.longitude),
      child: Icon(
        CupertinoIcons.bus,
        color: Colors.greenAccent.shade700,
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
                onPressed: () => Navigator.pop(context),
                child: const Text("OKE"),
              ),
              TextButton(
                onPressed:
                    () =>
                        AppSettings.openAppSettings(type: AppSettingsType.wifi),
                child: const Text("BUKA PENGATURAN"),
              ),
            ],
          ),
    );
  }

  double getRecommendedZoom(LatLng currentPos) {
    if (currentStopIndex >= busStops.length) return 15.0;

    final nextStop = busStops[currentStopIndex];
    final distanceKm = Distance().as(
      LengthUnit.Kilometer,
      currentPos,
      nextStop,
    );

    if (distanceKm > 10) return 13.0;
    if (distanceKm > 5) return 14.0;
    if (distanceKm > 3) return 15.0;
    if (distanceKm > 1) return 16.0;
    return 17.0;
  }

  Future<void> generateRoutePolyline() async {
    if (currentStopIndex >= busStops.length || busLocations.isEmpty) return;

    final busPos = LatLng(
      busLocations[selectedBusId.value]?.latitude ?? 0.0,
      busLocations[selectedBusId.value]?.longitude ?? 0.0,
    );
    final nextStop = busStops[currentStopIndex];

    try {
      final routedPath = await getRouteFromOpenRouteService(busPos, nextStop);
      routePoints.assignAll(routedPath);
      print('Generated routed polyline with \${routePoints.length} points');
    } catch (e) {
      print("Routing error: \$e");
    }
  }

  Future<List<LatLng>> getRouteFromOpenRouteService(
    LatLng start,
    LatLng end,
  ) async {
    const apiKey =
        'eyJvcmciOiI1YjNjZTM1OTc4NTExMTAwMDFjZjYyNDgiLCJpZCI6IjIyZDBkZDY2M2JjZDRlMzA5NDI2Mzg5YWRmYmNkMzNlIiwiaCI6Im11cm11cjY0In0=';
    final url =
        "https://api.openrouteservice.org/v2/directions/driving-car?api_key=$apiKey&start=${start.longitude},${start.latitude}&end=${end.longitude},${end.latitude}";

    final response = await http.get(Uri.parse(url));
    print('Route points: ${routePoints.length}');
    print('Request URL: $url');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final coordinates = data['features'][0]['geometry']['coordinates'];
      return coordinates
          .map<LatLng>((coord) => LatLng(coord[1], coord[0]))
          .toList();
    } else {
      throw Exception('Failed to get route from OpenRouteService');
    }
  }
}
