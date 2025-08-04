import '../models/airplane.dart';
import '../repositories/airplane_repository.dart';
import '../models/airplane_entity.dart';

/// Service class for managing business logic related to airplanes.
class AirplaneService {
  final AirplaneRepository airplaneRepository;

  /// Constructor for AirplaneService, requires an instance of AirplaneRepository.
  AirplaneService(this.airplaneRepository);

  /// Retrieves all airplanes and converts them to the Airplane model.
  Future<List<Airplane>> getAllAirplanes() async {
    final entities = await airplaneRepository.getAllAirplanes();
    return entities.map((entity) => entity.toAirplane()).toList();
  }

  /// Retrieves a specific airplane by its ID and converts it to the Airplane model.
  Future<Airplane?> getAirplaneById(int id) async {
    final entity = await airplaneRepository.getAirplaneById(id);
    return entity?.toAirplane();
  }

  /// Adds a new airplane by converting it to an entity and passing it to the repository.
  Future<void> addAirplane(Airplane airplane) async {
    final entity = AirplaneEntity.fromAirplane(airplane);
    await airplaneRepository.insertAirplane(entity);
  }

  /// Updates an existing airplane by converting it to an entity and passing it to the repository.
  Future<void> updateAirplane(Airplane airplane) async {
    final entity = AirplaneEntity(
      id: airplane.id,
      type: airplane.type,
      numberOfPassengers: airplane.numberOfPassengers,
      maxSpeed: airplane.maxSpeed,
      range: airplane.range,
    );
    await airplaneRepository.updateAirplane(entity);
  }

  /// Deletes an airplane by finding it by its ID and passing it to the repository.
  Future<void> deleteAirplane(int id) async {
    final airplane = await getAirplaneById(id);
    if (airplane != null) {
      final entity = AirplaneEntity.fromAirplane(airplane);
      await airplaneRepository.deleteAirplane(entity);
    }
  }
}