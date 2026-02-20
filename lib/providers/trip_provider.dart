import 'package:flutter/material.dart';
import '../models/trip_model.dart';
import '../services/sun_calculator.dart';

class TripProvider extends ChangeNotifier {
  TripModel? _currentTrip;

  TripModel? get currentTrip => _currentTrip;
  bool get hasTrip => _currentTrip != null;

  /// Calculates and stores the trip. Returns the result.
  TripModel planTrip(String from, String to, DateTime departureTime) {
    final trip = SunCalculator.calculate(from, to, departureTime);
    _currentTrip = trip;
    notifyListeners();
    return trip;
  }

  void clearTrip() {
    _currentTrip = null;
    notifyListeners();
  }
}
