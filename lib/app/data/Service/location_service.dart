// lib/features/bustracking/services/location_service.dart
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../models/bus_location.dart';

class LocationService {
  Future<BusLocation?> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return null;
    }

    if (permission == LocationPermission.deniedForever) return null;

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return BusLocation(
      id: 'my_bus',
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  double calculateDistance(List<LatLng> points) {
    double distance = 0;
    final distanceCalculator = Distance();
    for (int i = 1; i < points.length; i++) {
      distance += distanceCalculator(points[i - 1], points[i]);
    }
    return distance / 1000.0;
  }
}