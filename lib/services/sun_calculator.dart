import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../models/trip_model.dart';

class SunCalculator {
  // ── World city database ─────────────────────────────────────────────────
  // [lat, lon] in decimal degrees
  static const Map<String, List<double>> _cities = {
    // ── Bangladesh ──────────────────────────────────────────────────────
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
    'sirajganj': [24.453, 89.701],
    'natore': [24.420, 88.983],
    'chapai nawabganj': [24.592, 88.278],
    'kurigram': [25.807, 89.636],
    'lalmonirhat': [25.918, 89.449],
    'nilphamari': [25.932, 88.856],
    'panchagarh': [26.341, 88.555],
    'thakurgaon': [26.033, 88.461],
    'joypurhat': [25.096, 89.044],
    'naogaon': [24.793, 88.952],
    'chapainawabganj': [24.592, 88.278],
    'satkhira': [22.717, 89.071],
    'bagerhat': [22.651, 89.785],
    'jhenaidah': [23.545, 89.153],
    'magura': [23.487, 89.420],
    'narail': [23.173, 89.513],
    'gopalganj': [23.004, 89.827],
    'madaripur': [23.164, 90.202],
    'shariatpur': [23.242, 90.435],
    'chandpur': [23.240, 90.663],
    'lakshmipur': [22.945, 90.831],
    'feni': [23.017, 91.396],
    'khagrachhari': [23.119, 91.985],
    'rangamati': [22.641, 92.198],
    'bandarban': [22.195, 92.218],
    'cox\'s bazar': [21.436, 92.012],

    // ── India ────────────────────────────────────────────────────────────
    'delhi': [28.613, 77.209],
    'new delhi': [28.613, 77.209],
    'mumbai': [19.076, 72.877],
    'bombay': [19.076, 72.877],
    'kolkata': [22.572, 88.363],
    'calcutta': [22.572, 88.363],
    'chennai': [13.082, 80.270],
    'madras': [13.082, 80.270],
    'bangalore': [12.971, 77.594],
    'bengaluru': [12.971, 77.594],
    'hyderabad': [17.385, 78.486],
    'ahmedabad': [23.022, 72.571],
    'pune': [18.520, 73.856],
    'jaipur': [26.913, 75.787],
    'surat': [21.170, 72.831],
    'lucknow': [26.846, 80.946],
    'kanpur': [26.449, 80.331],
    'nagpur': [21.145, 79.082],
    'visakhapatnam': [17.686, 83.218],
    'agra': [27.177, 78.008],
    'varanasi': [25.317, 82.973],
    'patna': [25.594, 85.137],
    'bhopal': [23.259, 77.412],
    'ludhiana': [30.900, 75.857],
    'chandigarh': [30.733, 76.779],
    'kochi': [9.931, 76.267],
    'cochin': [9.931, 76.267],
    'guwahati': [26.144, 91.736],
    'coimbatore': [11.017, 76.956],
    'amritsar': [31.634, 74.872],
    'indore': [22.719, 75.857],
    'thane': [19.218, 72.978],
    'nashik': [19.997, 73.789],
    'aurangabad': [19.876, 75.343],
    'ranchi': [23.344, 85.310],
    'jabalpur': [23.181, 79.986],
    'gwalior': [26.218, 78.182],
    'vijayawada': [16.506, 80.648],
    'madurai': [9.919, 78.120],
    'raipur': [21.251, 81.630],
    'kota': [25.180, 75.850],
    'gurgaon': [28.458, 77.028],
    'noida': [28.535, 77.391],
    'shimla': [31.104, 77.167],
    'dehradun': [30.316, 78.032],
    'siliguri': [26.726, 88.397],
    'goa': [15.491, 73.828],
    'panaji': [15.491, 73.828],
    'mangalore': [12.914, 74.856],
    'thiruvananthapuram': [8.524, 76.936],
    'trivandrum': [8.524, 76.936],
    'bhubaneswar': [20.296, 85.825],
    'cuttack': [20.462, 85.880],

    // ── Pakistan ─────────────────────────────────────────────────────────
    'karachi': [24.860, 67.010],
    'lahore': [31.558, 74.358],
    'islamabad': [33.738, 73.084],
    'rawalpindi': [33.597, 73.043],
    'faisalabad': [31.418, 73.079],
    'multan': [30.195, 71.473],
    'peshawar': [34.014, 71.580],
    'quetta': [30.184, 67.007],
    'hyderabad pakistan': [25.396, 68.374],
    'gujranwala': [32.162, 74.186],
    'sialkot': [32.499, 74.536],

    // ── Nepal ────────────────────────────────────────────────────────────
    'kathmandu': [27.700, 85.316],
    'pokhara': [28.209, 83.985],
    'biratnagar': [26.455, 87.273],
    'lalitpur': [27.667, 85.318],
    'bhaktapur': [27.671, 85.428],
    'birgunj': [27.012, 84.877],
    'dharan': [26.812, 87.283],

    // ── Sri Lanka ────────────────────────────────────────────────────────
    'colombo': [6.927, 79.861],
    'kandy': [7.291, 80.636],
    'galle': [6.053, 80.221],
    'jaffna': [9.661, 80.014],
    'negombo': [7.209, 79.838],

    // ── Myanmar ──────────────────────────────────────────────────────────
    'yangon': [16.866, 96.195],
    'rangoon': [16.866, 96.195],
    'mandalay': [21.978, 96.084],
    'naypyidaw': [19.745, 96.129],
    'mawlamyine': [16.490, 97.628],

    // ── Southeast Asia ───────────────────────────────────────────────────
    'bangkok': [13.756, 100.501],
    'kuala lumpur': [3.140, 101.686],
    'kl': [3.140, 101.686],
    'singapore': [1.352, 103.820],
    'jakarta': [-6.214, 106.845],
    'surabaya': [-7.257, 112.752],
    'manila': [14.599, 120.984],
    'hanoi': [21.028, 105.804],
    'ho chi minh': [10.823, 106.629],
    'saigon': [10.823, 106.629],
    'phnom penh': [11.562, 104.916],
    'vientiane': [17.966, 102.613],
    'chiang mai': [18.788, 98.984],
    'phuket': [7.878, 98.392],
    'bali': [-8.409, 115.190],
    'denpasar': [-8.655, 115.217],
    'penang': [5.414, 100.329],
    'george town': [5.414, 100.329],
    'johor bahru': [1.492, 103.741],

    // ── China ────────────────────────────────────────────────────────────
    'beijing': [39.914, 116.392],
    'shanghai': [31.224, 121.469],
    'guangzhou': [23.129, 113.264],
    'shenzhen': [22.543, 114.058],
    'chengdu': [30.657, 104.065],
    'chongqing': [29.563, 106.551],
    'wuhan': [30.593, 114.305],
    'xian': [34.341, 108.940],
    'tianjin': [39.125, 117.190],
    'nanjing': [32.060, 118.796],
    'hangzhou': [30.287, 120.153],
    'kunming': [24.880, 102.832],
    'hong kong': [22.320, 114.170],
    'macau': [22.193, 113.543],
    'taipei': [25.042, 121.564],

    // ── Japan & Korea ────────────────────────────────────────────────────
    'tokyo': [35.689, 139.692],
    'osaka': [34.693, 135.502],
    'seoul': [37.566, 126.978],
    'busan': [35.180, 129.075],
    'kyoto': [35.012, 135.768],

    // ── Middle East ──────────────────────────────────────────────────────
    'dubai': [25.204, 55.270],
    'abu dhabi': [24.453, 54.377],
    'riyadh': [24.688, 46.722],
    'jeddah': [21.485, 39.192],
    'mecca': [21.389, 39.858],
    'medina': [24.524, 39.569],
    'doha': [25.286, 51.533],
    'kuwait city': [29.369, 47.978],
    'muscat': [23.614, 58.593],
    'bahrain': [26.215, 50.586],
    'manama': [26.215, 50.586],
    'tehran': [35.689, 51.389],
    'baghdad': [33.340, 44.401],
    'beirut': [33.888, 35.495],
    'amman': [31.955, 35.945],
    'damascus': [33.510, 36.291],
    'jerusalem': [31.769, 35.216],
    'tel aviv': [32.087, 34.780],
    'istanbul': [41.015, 28.979],
    'ankara': [39.933, 32.860],

    // ── Europe ───────────────────────────────────────────────────────────
    'london': [51.507, -0.127],
    'paris': [48.856, 2.352],
    'berlin': [52.520, 13.405],
    'madrid': [40.416, -3.703],
    'barcelona': [41.385, 2.173],
    'rome': [41.902, 12.496],
    'milan': [45.465, 9.186],
    'amsterdam': [52.379, 4.900],
    'brussels': [50.850, 4.351],
    'vienna': [48.208, 16.373],
    'zurich': [47.378, 8.540],
    'stockholm': [59.334, 18.065],
    'oslo': [59.913, 10.752],
    'copenhagen': [55.676, 12.568],
    'helsinki': [60.169, 24.939],
    'warsaw': [52.229, 21.012],
    'prague': [50.075, 14.438],
    'budapest': [47.498, 19.040],
    'bucharest': [44.426, 26.103],
    'moscow': [55.755, 37.617],
    'kyiv': [50.450, 30.523],
    'athens': [37.979, 23.717],
    'lisbon': [38.717, -9.139],

    // ── Africa ───────────────────────────────────────────────────────────
    'cairo': [30.044, 31.235],
    'lagos': [6.524, 3.379],
    'nairobi': [-1.286, 36.820],
    'cape town': [-33.925, 18.424],
    'johannesburg': [-26.204, 28.048],
    'addis ababa': [9.025, 38.747],
    'accra': [5.603, -0.186],
    'casablanca': [33.589, -7.610],
    'tunis': [36.819, 10.166],
    'algiers': [36.752, 3.042],
    'dakar': [14.693, -17.443],
    'kampala': [0.347, 32.583],
    'dar es salaam': [-6.792, 39.208],
    'khartoum': [15.551, 32.532],
    'abuja': [9.058, 7.495],

    // ── Americas ─────────────────────────────────────────────────────────
    'new york': [40.713, -74.006],
    'los angeles': [34.052, -118.243],
    'chicago': [41.878, -87.629],
    'houston': [29.760, -95.369],
    'phoenix': [33.448, -112.074],
    'toronto': [43.653, -79.383],
    'vancouver': [49.282, -123.120],
    'montreal': [45.508, -73.587],
    'mexico city': [19.432, -99.133],
    'sao paulo': [-23.550, -46.633],
    'rio de janeiro': [-22.906, -43.172],
    'buenos aires': [-34.603, -58.381],
    'lima': [-12.046, -77.043],
    'bogota': [4.710, -74.072],
    'santiago': [-33.457, -70.648],
    'caracas': [10.480, -66.879],
    'havana': [23.136, -82.358],
    'miami': [25.775, -80.208],
    'washington': [38.907, -77.037],

    // ── Australia & Oceania ──────────────────────────────────────────────
    'sydney': [-33.869, 151.209],
    'melbourne': [-37.814, 144.963],
    'brisbane': [-27.470, 153.021],
    'perth': [-31.950, 115.860],
    'auckland': [-36.867, 174.766],
    'wellington': [-41.286, 174.776],
  };

  // ── City lookup ─────────────────────────────────────────────────────────

  static List<double>? _findCity(String name) {
    final key = name.trim().toLowerCase();
    if (_cities.containsKey(key)) return _cities[key];
    for (final entry in _cities.entries) {
      if (entry.key.startsWith(key) || key.startsWith(entry.key)) {
        return entry.value;
      }
    }
    for (final entry in _cities.entries) {
      if (entry.key.contains(key) || key.contains(entry.key)) {
        return entry.value;
      }
    }
    return null;
  }

  /// Returns [lat, lon] of named city, or null if unknown.
  static List<double>? cityCoords(String name) => _findCity(name);

  // ── Nearest city (for GPS lookup) ──────────────────────────────────────

  /// Returns display name of the nearest known city to [lat]/[lon].
  static String nearestCity(double lat, double lon) {
    String bestKey = 'dhaka';
    double minDist = double.infinity;
    for (final entry in _cities.entries) {
      final d = _distKm(lat, lon, entry.value[0], entry.value[1]);
      if (d < minDist) {
        minDist = d;
        bestKey = entry.key;
      }
    }
    return _cap(bestKey);
  }

  // ── Sun position (NOAA algorithm) ──────────────────────────────────────

  /// Returns sun azimuth in degrees (0=N, 90=E, 180=S, 270=W).
  /// Returns -1 when the sun is below the horizon.
  static double getSunAzimuth(double lat, double lon, DateTime time) {
    final n = _dayOfYear(time);
    final tzHours = time.timeZoneOffset.inMinutes / 60.0;
    final hourDec = time.hour + time.minute / 60.0;

    // Solar declination
    final b = 360.0 / 365.0 * (n - 81);
    final bRad = b * math.pi / 180;
    final declRad = 23.45 * math.sin(bRad) * math.pi / 180;

    // Equation of time (minutes)
    final eqt = 9.87 * math.sin(2 * bRad) -
        7.53 * math.cos(bRad) -
        1.5 * math.sin(bRad);

    // Local Solar Time correction (minutes)
    final tc = 4.0 * (lon - 15.0 * tzHours) + eqt;
    final lst = hourDec + tc / 60.0;

    // Hour angle (negative = morning, positive = afternoon)
    final haRad = (lst - 12.0) * 15.0 * math.pi / 180;
    final latRad = lat * math.pi / 180;

    // Solar altitude
    final sinAlt = math.sin(latRad) * math.sin(declRad) +
        math.cos(latRad) * math.cos(declRad) * math.cos(haRad);
    if (sinAlt <= 0.0) return -1; // below horizon

    final altRad = math.asin(sinAlt.clamp(-1.0, 1.0));

    // Solar azimuth (from North, clockwise)
    final cosAz = (math.sin(declRad) - sinAlt * math.sin(latRad)) /
        (math.cos(altRad) * math.cos(latRad));
    final az = math.acos(cosAz.clamp(-1.0, 1.0)) * 180 / math.pi;

    // Morning: azimuth < 180 (East half); Afternoon: azimuth > 180 (West half)
    return (lst - 12.0) <= 0 ? az : 360.0 - az;
  }

  /// Offset of sun dot on a compass circle of given [radius].
  static Offset sunDotOffset(double azimuthDeg, double radius) {
    final rad = azimuthDeg * math.pi / 180;
    return Offset(radius * math.sin(rad), -radius * math.cos(rad));
  }

  // ── Route bearing ───────────────────────────────────────────────────────

  static double _bearing(double lat1, double lon1, double lat2, double lon2) {
    final dLon = _toRad(lon2 - lon1);
    final y = math.sin(dLon) * math.cos(_toRad(lat2));
    final x = math.cos(_toRad(lat1)) * math.sin(_toRad(lat2)) -
        math.sin(_toRad(lat1)) * math.cos(_toRad(lat2)) * math.cos(dLon);
    return (math.atan2(y, x) * 180 / math.pi + 360) % 360;
  }

  static String _bearingLabel(double b) {
    if (b < 22.5 || b >= 337.5) return 'North';
    if (b < 67.5) return 'North-East';
    if (b < 112.5) return 'East';
    if (b < 157.5) return 'South-East';
    if (b < 202.5) return 'South';
    if (b < 247.5) return 'South-West';
    if (b < 292.5) return 'West';
    return 'North-West';
  }

  // ── Main calculation entry point ────────────────────────────────────────

  /// Calculates best seat recommendation.
  ///
  /// [fromLat]/[fromLon] — exact GPS coords of origin (optional).
  /// When provided they are used for solar position; otherwise the city
  /// database coordinates (or Bangladesh centre as fallback) are used.
  static TripModel calculate(
    String from,
    String to,
    DateTime time, {
    double? fromLat,
    double? fromLon,
  }) {
    final fromCoords = (fromLat != null && fromLon != null)
        ? [fromLat, fromLon]
        : _findCity(from);
    final toCoords = _findCity(to);

    // Use actual coords if available, else Bangladesh centre as fallback
    final originLat = fromCoords?[0] ?? 23.810;
    final originLon = fromCoords?[1] ?? 90.412;

    // Route bearing
    double bearing;
    if (fromCoords != null && toCoords != null) {
      bearing =
          _bearing(fromCoords[0], fromCoords[1], toCoords[0], toCoords[1]);
    } else {
      bearing = 90.0; // unknown route → default East
    }
    final headingLabel = _bearingLabel(bearing);

    // Sun azimuth using proper formula with actual origin coordinates
    final sunAz = getSunAzimuth(originLat, originLon, time);
    final isNight = sunAz < 0;

    String sunSide, shadeSide;
    if (isNight) {
      sunSide = 'none';
      shadeSide = 'right';
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
      origin: _cap(from.trim()),
      destination: _cap(to.trim()),
      departureTime: time,
      headingLabel: headingLabel,
      headingDegrees: bearing,
      sunAzimuth: isNight ? 0 : sunAz,
      isNight: isNight,
      sunSide: sunSide,
      shadeSide: shadeSide,
      shadedSeats: shadedSeats,
      originLat: originLat,
      originLon: originLon,
    );
  }

  // ── Helpers ─────────────────────────────────────────────────────────────

  static double _toRad(double d) => d * math.pi / 180;

  static double _distKm(double lat1, double lon1, double lat2, double lon2) {
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

  static int _dayOfYear(DateTime dt) =>
      dt.difference(DateTime(dt.year, 1, 1)).inDays + 1;

  static String _cap(String s) => s.split(' ').map((w) {
        if (w.isEmpty) return w;
        return w[0].toUpperCase() + w.substring(1).toLowerCase();
      }).join(' ');
}
