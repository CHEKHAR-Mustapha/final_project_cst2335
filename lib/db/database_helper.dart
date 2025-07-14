import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/airplane.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  static Database? _db;

  DatabaseHelper._internal();

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'airplanes.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE airplanes (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        type TEXT NOT NULL,
        passengers INTEGER NOT NULL,
        speed INTEGER NOT NULL,
        range INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertAirplane(Airplane airplane) async {
    final db = await database;
    return await db.insert('airplanes', airplane.toMap());
  }

  Future<List<Airplane>> getAirplanes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('airplanes');

    return List.generate(maps.length, (i) {
      return Airplane.fromMap(maps[i]);
    });
  }

  Future<int> updateAirplane(Airplane airplane) async {
    final db = await database;
    return await db.update(
      'airplanes',
      airplane.toMap(),
      where: 'id = ?',
      whereArgs: [airplane.id],
    );
  }

  Future<int> deleteAirplane(int id) async {
    final db = await database;
    return await db.delete(
      'airplanes',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
