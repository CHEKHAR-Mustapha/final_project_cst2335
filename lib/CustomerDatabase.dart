import 'dart:async';
import 'package:floor/floor.dart';
import 'package:cst2335_final_project/CustomerItem.dart';
import 'CustomerDAO.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'CustomerDatabase.g.dart';

@Database(version: 1, entities: [CustomerItem])
abstract class CustomerDatabase extends FloorDatabase{

  CustomerDAO get getDAO;
}