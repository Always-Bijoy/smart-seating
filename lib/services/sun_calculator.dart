import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/trip_model.dart';

class SunCalculator {
  static const Map<String, List<double>> _cities = {
    'manikganj': [23.864, 89.990],
    'dhaka': [23.810, 90.412],
    'chittagong': [22.335, 91.835],
    'sylhet': [24.900, 91.872],
    'rajshahi': [24.374, 88.601],
    'khulna': [22.816, 89.551],
    'comilla': [23.461, 91.188],
    'cumilla': [23.461, 91.188],
    'mymensingh': [24.746, 90.407],
    'gazipur': [23.999, 90.415],
    'narsingdi': [23.921, 90.714],
    'tangail': [24.251, 89.922],
    'faridpur': [23.604, 89.842],
    'narayanganj': [23.623, 90.499],
    'jessore': [23.166, 89.218],
    'bogra': [24.851, 89.370],
    'barishal': [22.701, 90.370],
    'barisal': [22.701, 90.370],
    'rangpur': [25.746, 89.252],
    'dinajpur': [25.627, 88.638],
    'pabna': [24.006, 89.244],
    'noakhali': [22.869, 91.099],
    'brahmanbaria': [23.960, 91.112],
    'habiganj': [24.374, 91.415],
    'moulvibazar': [24.483, 91.778],
    'coxs bazar': [21.436, 92.012],
    'cox bazar': [21.436, 92.012],
    'savar': [23.847, 90.266],
    'munshiganj': [23.540, 90.528],
    'kishoreganj': [24.444, 90.776],
    'jamalpur': [24.909, 89.937],
    'sherpur': [25.022, 90.016],
    'netrokona': [24.883, 90.727],
    'sunamganj': [25.066, 91.400],
  };

  static List<double>? _findCity(String name) {
    final key = name.trim().toLowerCase();
    if (_cities.containsKey(key)) return _cities[key];
    // Partial / prefix match
    for (final entry in _cities.entries) {
      if (entry.key.startsWith(key) || key.startsWith(entry.key)) {
        return entry.value;
      }
    }
    // Contains match
    for (final entry in _cities.entries) {
      if (entry.key.contains(key) || key.contains(entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  static double _toRad(double d) => d * math.pi / 180;

  static double _distanceKm(
      double lat1, double lon1, double lat2, double lon2) {
    const r = 6371.0;
    final dLat = _toRad(lat2 - lat1);
    final dLon = _toRad(lon2 - lon1);
    final a = math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRad(lat1)) *
            math.cos(_toRad(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);
    return r * 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
  }

  /// Returns the display name of the nearest known city to [lat]/[lon].
  static String nearestCity(double lat, double lon) {
    String bestKey = 'dhaka';
    double minDist = double.infinity;
    for (final entry in _cities.entries) {
      final d = _distanceKm(lat, lon, entry.value[0], entry.value[1]);
      if (d < minDist) {
        minDist = d;
        bestKey = entry.key;
      }
    }
    return _capitalise(bestKey);
  }

  static double _calcBearing(
      double lat1, double lon1, double lat2, double lon2) {
    final dLon = _toRad(lon2 - lon1);
    final y = math.sin(dLon) * math.cos(_toRad(lat2));
    final x = math.cos(_toRad(lat1)) * math.sin(_toRad(lat2)) -
        math.sin(_toRad(lat1)) * math.cos(_toRad(lat2)) * math.cos(dLon);
    return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
  }

  static String _bearingToLabel(double b) {
    if (b < 22.5 || b >= 337.5) return 'North';
    if (b < 67.5) return 'North-East';
    if (b < 112.5) return 'East';
    if (b < 157.5) return 'South-East';
    if (b < 202.5) return 'South';
    if (b < 247.5) return 'South-West';
    if (b < 292.5) return 'West';
    return 'North-West';
  }

  /// Returns sun azimuth in degrees (0=N, 90=E, 180=S, 270=W).
  /// Returns -1 if sun is below horizon (night).
  static double getSunAzimuth(DateTime time) {
    final hour = time.hour + time.minute / 60.0;
    // Bangladesh sunrise ~6 AM, solar noon ~12 PM (South), sunset ~18 PM
    if (hour < 6.0 || hour >= 18.0) return -1;
    return 90.0 + (hour - 6.0) * 15.0;
  }

  /// Computes x,y offset of sun dot on a compass circle of given radius.
  static Offset sunDotOffset(double azimuthDeg, double radius) {
    final rad = _toRad(azimuthDeg);
    return Offset(radius * math.sin(rad), -radius * math.cos(rad));
  }

  static TripModel calculate(String from, String to, DateTime departureTime) {
    final fromCoords = _findCity(from);
    final toCoords = _findCity(to);

    double bearing;
    if (fromCoords != null && toCoords != null) {
      bearing = _calcBearing(
          fromCoords[0], fromCoords[1], toCoords[0], toCoords[1]);
    } else {
      bearing = 90.0; // default heading East when cities unknown
    }

    final headingLabel = _bearingToLabel(bearing);
    final sunAz = getSunAzimuth(departureTime);
    final isNight = sunAz < 0;

    String sunSide;
    String shadeSide;

    if (isNight) {
      sunSide = 'none';
      shadeSide = 'right'; // no sun, default recommendation
    } else {
      final rel = (sunAz - bearing + 360) % 360;
      if (rel < 180) {
        sunSide = 'right';
        shadeSide = 'left';
      } else {
        sunSide = 'left';
        shadeSide = 'right';
      }
    }

    final Set<int> shadedSeats = shadeSide == 'right'
        ? {2, 3, 6, 7, 10, 11, 14, 15, 18, 19}
        : {0, 1, 4, 5, 8, 9, 12, 13, 16, 17};

    return TripModel(
      origin: _capitalise(from.trim()),
      destination: _capitalise(to.trim()),
      departureTime: departureTime,
      headingLabel: headingLabel,
      headingDegrees: bearing,
      sunAzimuth: isNight ? 0 : sunAz,
      isNight: isNight,
      sunSide: sunSide,
      shadeSide: shadeSide,
      shadedSeats: shadedSeats,
    );
  }

  static String _capitalise(String s) {
    if (s.isEmpty) return s;
    return s.split(' ').map((w) {
      if (w.isEmpty) return w;
      return w[0].toUpperCase() + w.substring(1).toLowerCase();
    }).join(' ');
  }
}
