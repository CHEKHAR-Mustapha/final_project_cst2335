import '../models/airplane_entity.dart';
import 'airplane_dao.dart';

/// Repository class for managing airplane data operations.
/// Acts as a layer between the DAO and the service.
class AirplaneRepository {
  final AirplaneDao airplaneDao;

  /// Constructor for AirplaneRepository, requires an instance of AirplaneDao.
  AirplaneRepository(this.airplaneDao);

  /// Retrieves all airplanes through the DAO.
  Future<List<AirplaneEntity>> getAllAirplanes() {
    return airplaneDao.findAllAirplanes();
  }

  /// Retrieves a specific airplane by its ID through the DAO.
  Future<AirplaneEntity?> getAirplaneById(int id) {
    return airplaneDao.findAirplaneById(id);
  }

  /// Inserts a new airplane through the DAO.
  Future<void> insertAirplane(AirplaneEntity airplane) {
    return airplaneDao.insertAirplane(airplane);
  }

  /// Updates an existing airplane through the DAO.
  Future<void> updateAirplane(AirplaneEntity airplane) {
    return airplaneDao.updateAirplane(airplane);
  }

  /// Deletes an airplane through the DAO.
  Future<void> deleteAirplane(AirplaneEntity airplane) {
    return airplaneDao.deleteAirplane(airplane);
  }
}