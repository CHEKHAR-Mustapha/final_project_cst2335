import 'package:floor/floor.dart';
import 'reservation_entity.dart';

@dao
abstract class ReservationDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertReservation(Reservation reservation);

  @Query('SELECT * FROM reservations')
  Future<List<Reservation>> getAllReservations();

  @Query('SELECT * FROM reservations WHERE customerId = :customerId')
  Future<List<Reservation>> getReservationsByCustomerId(int customerId);

  @Query('DELETE FROM reservations WHERE id = :id')
  Future<void> deleteReservation(int id);
}
