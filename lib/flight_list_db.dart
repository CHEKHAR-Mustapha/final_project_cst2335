import 'dart:async';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'flight_entity.dart';
import 'flight_list_dao.dart';

part 'flight_list_db.g.dart';
///Flight entity database
@Database(version: 1, entities: [FlightEntity])
abstract class FlightDatabase extends FloorDatabase {
  FlightDao get flightDao;
}