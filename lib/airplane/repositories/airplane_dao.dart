import 'package:floor/floor.dart';
import '../models/airplane_entity.dart';

/// Data Access Object (DAO) for performing CRUD operations on the AirplaneEntity.
@dao
abstract class AirplaneDao {

  /// Retrieves all airplanes from the database.
  @Query('SELECT * FROM AirplaneEntity')
  Future<List<AirplaneEntity>> findAllAirplanes();

  /// Retrieves a specific airplane by its ID.
  @Query('SELECT * FROM AirplaneEntity WHERE id = :id')
  Future<AirplaneEntity?> findAirplaneById(int id);

  /// Inserts a new airplane into the database.
  @insert
  Future<void> insertAirplane(AirplaneEntity airplane);

  /// Updates an existing airplane in the database.
  @update
  Future<void> updateAirplane(AirplaneEntity airplane);

  /// Deletes an airplane from the database.
  @delete
  Future<void> deleteAirplane(AirplaneEntity airplane);
}