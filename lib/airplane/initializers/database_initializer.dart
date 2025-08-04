import '../repositories/airplane_repository.dart';
import '../services/airplane_service.dart';
import '../repositories/database.dart';

/// Utility class for initializing the airplane service and the database.
class DatabaseInitializer {

  /// Initializes the AirplaneService by setting up the database and repository.
  static Future<AirplaneService> initializeAirplaneService() async {

    final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();

    final airplaneDao = database.airplaneDao;
    final airplaneRepository = AirplaneRepository(airplaneDao);

    return AirplaneService(airplaneRepository);
  }
}