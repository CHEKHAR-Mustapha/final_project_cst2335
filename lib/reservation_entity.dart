import 'package:floor/floor.dart';

@Entity(tableName: 'reservations')
class Reservation {
  @primaryKey

  final int customerId;
  final int flightId;
  final String reservationName;
  final String date;

  Reservation({
    required this.customerId,
    required this.flightId,
    required this.reservationName,
    required this.date,
  });
}
