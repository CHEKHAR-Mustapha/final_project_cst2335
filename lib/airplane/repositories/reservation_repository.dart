import '../../reservation_entity.dart';
import '../../reservation_dao.dart';

class ReservationRepository {
  final ReservationDao _dao;

  ReservationRepository(this._dao);

  Future<List<Reservation>> getAllReservations() => _dao.getAllReservations();

  Future<void> insertReservation(Reservation reservation) =>
      _dao.insertReservation(reservation);
}
