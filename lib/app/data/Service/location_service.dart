import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../models/bus_location.dart';

class LocationService {
  static RxBool isConnected = false.obs;

  static Future<BusLocation?> getBusLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return null;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) return null;

    try {
      final position = await Geolocator.getCurrentPosition(
        // ignore: deprecated_member_use
        desiredAccuracy: LocationAccuracy.high,
        // ignore: deprecated_member_use
        timeLimit: const Duration(seconds: 10),
      );
      return BusLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        id: 'my_bus',
      );
    } on TimeoutException {
      return null;
    }
  }

  static Future<String?> getAddressFromLatLng(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        lat,
        lng,
      ).timeout(const Duration(seconds: 5));

      if (placemarks.isNotEmpty) {
        final place = placemarks.first;
        return '${place.name}, ${place.subLocality}, ${place.locality}, '
            '${place.administrativeArea}, ${place.country}';
      }
    } catch (e) {
      if (kDebugMode) {
        print("Gagal dapat alamat dari koordinat: $e");
      }
    }
    return null;
  }

  static Future<void> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      isConnected.value = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      isConnected.value = false;
    }
  }

  static double calculateDistance(List<LatLng> routePoints) {
    double distance = 0;
    final Distance distanceCalculator = Distance();
    for (int i = 1; i < routePoints.length; i++) {
      distance += distanceCalculator(routePoints[i - 1], routePoints[i]);
    }
    return distance / 1000.0; // dalam kilometer
  }
}
