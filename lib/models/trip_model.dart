class TripModel {
  final String origin;
  final String destination;
  final DateTime departureTime;

  /// Human-readable heading, e.g. "South-East"
  final String headingLabel;

  /// Bearing in degrees 0–360 (clockwise from North)
  final double headingDegrees;

  /// Sun azimuth in degrees 0–360 (0 when night)
  final double sunAzimuth;

  /// True when the sun is below the horizon at departure time
  final bool isNight;

  /// Which side of the bus the sun hits: 'left', 'right', or 'none'
  final String sunSide;

  /// The cool/shaded side to recommend: 'left' or 'right'
  final String shadeSide;

  /// Flat seat indices (row * 4 + col) that are in shade
  final Set<int> shadedSeats;

  TripModel({
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.headingLabel,
    required this.headingDegrees,
    required this.sunAzimuth,
    required this.isNight,
    required this.sunSide,
    required this.shadeSide,
    required this.shadedSeats,
  });

  String get formattedTime {
    final h = departureTime.hour;
    final m = departureTime.minute;
    final period = h >= 12 ? 'PM' : 'AM';
    final hour = h % 12 == 0 ? 12 : h % 12;
    final min = m.toString().padLeft(2, '0');
    return '$hour:$min $period';
  }

  String get shadeSideUpper => shadeSide.toUpperCase();

  String get sunSideUpper =>
      sunSide == 'none' ? 'NONE' : sunSide.toUpperCase();

  String get routeLabel => '$origin → $destination';

  String get chipLabel => '$formattedTime • Heading $headingLabel';

  String get heatBannerText => isNight
      ? 'No direct sunlight (nighttime travel)'
      : 'Intense heat on ${sunSideUpper.capitalize()}';

  String get recommendationDetail => isNight
      ? 'No sun glare — any seat is comfortable for this journey.'
      : 'Seats on the $shadeSideUpper side will be in full shade for your journey heading $headingLabel.';
}

extension _StringExt on String {
  String capitalize() =>
      isEmpty ? this : this[0].toUpperCase() + substring(1).toLowerCase();
}
