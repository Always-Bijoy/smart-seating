class TripModel {
  final String origin;
  final String destination;
  final String departureTime;
  final String weather;
  final String sunDirection;
  final String recommendedSide;
  final String shadeRows;

  const TripModel({
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.weather,
    required this.sunDirection,
    required this.recommendedSide,
    required this.shadeRows,
  });
}
