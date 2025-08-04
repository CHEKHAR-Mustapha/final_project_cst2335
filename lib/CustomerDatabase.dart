import 'dart:async';
import 'package:floor/floor.dart';
import 'package:final_project_cst2335/CustomerItem.dart';
import 'CustomerDAO.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'CustomerDatabase.g.dart';

@Database(version: 1, entities: [CustomerItem])
abstract class CustomerDatabase extends FloorDatabase{

  CustomerDAO get getDAO;
}