import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'airplane_dao.dart';
import '../models/airplane_entity.dart';
import '../../reservation_entity.dart';
import '../../reservation_dao.dart';
/// Database class for the application, responsible for managing the airplane + reservation database.
part 'database.g.dart';

@Database(version: 1, entities: [
  AirplaneEntity,
  Reservation,
])
abstract class AppDatabase extends FloorDatabase {
  AirplaneDao get airplaneDao;
  ReservationDao get reservationDao;
}