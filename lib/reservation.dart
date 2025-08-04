import 'package:floor/floor.dart';

@entity
class Reservation {
  @PrimaryKey(autoGenerate: true)
  final int? id;

  final int customerId;
  final int flightId;
  final DateTime flightDate;
  final String reservationName;

  Reservation({
    this.id,
    required this.customerId,
    required this.flightId,
    required this.flightDate,
    required this.reservationName,
  });
}