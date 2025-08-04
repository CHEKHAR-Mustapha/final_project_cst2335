import 'dart:async';
import 'package:floor/floor.dart';
import 'reservation_entity.dart';
import 'reservation_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'reservation_db.g.dart';

@Database(version: 1, entities: [Reservation])
abstract class ReservationDatabase extends FloorDatabase {
  ReservationDao get reservationDao;
}
