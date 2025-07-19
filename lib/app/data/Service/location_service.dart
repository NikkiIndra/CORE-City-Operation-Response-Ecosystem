import 'dart:async';
import 'dart:io';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../models/bus_location.dart';

class LocationService {
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
        desiredAccuracy: LocationAccuracy.high,
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
      print("Gagal dapat alamat dari koordinat: $e");
    }
    return null;
  }

  static Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup(
        'google.com',
      ).timeout(const Duration(seconds: 5));
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } catch (_) {
      return false;
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
