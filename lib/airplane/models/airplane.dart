/// Model class representing an airplane.
class Airplane {
  final int id;
  final String type;
  final int numberOfPassengers;
  final double maxSpeed;
  final double range;

  /// Constructor for Airplane, requires all fields to be provided.
  Airplane({
    required this.id,
    required this.type,
    required this.numberOfPassengers,
    required this.maxSpeed,
    required this.range,
  });
}