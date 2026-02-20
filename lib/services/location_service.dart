import 'package:geolocator/geolocator.dart';
import 'sun_calculator.dart';

enum LocationError { serviceDisabled, permissionDenied, permissionPermanentlyDenied, timeout, unknown }

class LocationResult {
  final String? city;
  final LocationError? error;
  const LocationResult.success(this.city) : error = null;
  const LocationResult.failure(this.error) : city = null;
  bool get isSuccess => city != null;
}

class LocationService {
  /// Requests permission if needed and returns the nearest known city name.
  static Future<LocationResult> getNearestCity() async {
    // Check if location hardware/service is on
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return const LocationResult.failure(LocationError.serviceDisabled);
    }

    // Check / request permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return const LocationResult.failure(LocationError.permissionDenied);
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return const LocationResult.failure(
          LocationError.permissionPermanentlyDenied);
    }

    // Fetch position
    try {
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
        ),
      ).timeout(const Duration(seconds: 15));

      final city =
          SunCalculator.nearestCity(position.latitude, position.longitude);
      return LocationResult.success(city);
    } on Exception {
      return const LocationResult.failure(LocationError.timeout);
    }
  }

  static String errorMessage(LocationError error) {
    switch (error) {
      case LocationError.serviceDisabled:
        return 'Location services are disabled. Please enable GPS.';
      case LocationError.permissionDenied:
        return 'Location permission denied.';
      case LocationError.permissionPermanentlyDenied:
        return 'Location permission permanently denied. Enable it in Settings.';
      case LocationError.timeout:
        return 'Could not get location. Please try again.';
      case LocationError.unknown:
        return 'Location unavailable.';
    }
  }
}
