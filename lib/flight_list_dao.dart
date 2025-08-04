
import 'package:floor/floor.dart';
import 'flight_entity.dart';
///flight entity DAO
@dao
abstract class FlightDao {

  ///findAllFlights finds all flights in Flight database
  @Query('SELECT * FROM FlightEntity')
  Future<List<FlightEntity>> findAllFlights();
  ///Find flight by Id finds specific Flight in database using unique Id
  @Query('SELECT * FROM FlightEntity WHERE id = :id')
  Stream<FlightEntity?> findFlightById(int id);
  ///Insert flight Into database
  @insert
  Future<void> insertFlight(FlightEntity flight);
  /// updates flight entity in dadtabase
  @update
  Future<void> updateFlight(FlightEntity flight);
  /// Deletes flight entity in database
  @delete
  Future<void> deleteFlight(FlightEntity flight);
}