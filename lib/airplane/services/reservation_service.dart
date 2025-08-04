import '../../reservation_dao.dart';
import '../../reservation_entity.dart';
import '../repositories/reservation_repository.dart';

class ReservationService {
  final ReservationDao reservationDao;

  ReservationService(this.reservationDao);

  Future<List<Reservation>> getReservations() async {
    return await reservationDao.getAllReservations();
  }

}

