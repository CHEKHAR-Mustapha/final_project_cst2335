import 'package:floor/floor.dart';

@entity
class FlightEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String departureCity;
  final String arrivalCity;
  final int departureTime;
  final int arrivalTime;
  ///Flight Entity Represents a flight betwenn two cities, with a departure and arrival date.
  FlightEntity(
      this.id,
      this.departureCity,
      this.arrivalCity,
      this.departureTime,
      this.arrivalTime,
      );
}