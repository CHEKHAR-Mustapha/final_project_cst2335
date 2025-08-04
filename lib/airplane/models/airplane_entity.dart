import 'package:floor/floor.dart';
import 'airplane.dart';

/// Entity class for representing an airplane in the database.
@entity
class AirplaneEntity {
  @primaryKey
  final int? id;
  final String type;
  final int numberOfPassengers;
  final double maxSpeed;
  final double range;

  /// Constructor for AirplaneEntity, with optional ID for database auto-generation.
  AirplaneEntity({
    this.id,
    required this.type,
    required this.numberOfPassengers,
    required this.maxSpeed,
    required this.range,
  });

  /// Converts this entity to an Airplane model.
  Airplane toAirplane() {
    return Airplane(
      id: id ?? 0,
      type: type,
      numberOfPassengers: numberOfPassengers,
      maxSpeed: maxSpeed,
      range: range,
    );
  }

  /// Creates an AirplaneEntity from an Airplane model.
  static AirplaneEntity fromAirplane(Airplane airplane) {
    return AirplaneEntity(
      id: airplane.id > 0 ? airplane.id : null,
      type: airplane.type,
      numberOfPassengers: airplane.numberOfPassengers,
      maxSpeed: airplane.maxSpeed,
      range: airplane.range,
    );
  }
}