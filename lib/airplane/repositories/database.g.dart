// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  AirplaneDao? _airplaneDaoInstance;

  ReservationDao? _reservationDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `AirplaneEntity` (`id` INTEGER, `type` TEXT NOT NULL, `numberOfPassengers` INTEGER NOT NULL, `maxSpeed` REAL NOT NULL, `range` REAL NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `reservations` (`customerId` INTEGER NOT NULL, `flightId` INTEGER NOT NULL, `reservationName` TEXT NOT NULL, `date` TEXT NOT NULL, PRIMARY KEY (`customerId`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  AirplaneDao get airplaneDao {
    return _airplaneDaoInstance ??= _$AirplaneDao(database, changeListener);
  }

  @override
  ReservationDao get reservationDao {
    return _reservationDaoInstance ??=
        _$ReservationDao(database, changeListener);
  }
}

class _$AirplaneDao extends AirplaneDao {
  _$AirplaneDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _airplaneEntityInsertionAdapter = InsertionAdapter(
            database,
            'AirplaneEntity',
            (AirplaneEntity item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'numberOfPassengers': item.numberOfPassengers,
                  'maxSpeed': item.maxSpeed,
                  'range': item.range
                }),
        _airplaneEntityUpdateAdapter = UpdateAdapter(
            database,
            'AirplaneEntity',
            ['id'],
            (AirplaneEntity item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'numberOfPassengers': item.numberOfPassengers,
                  'maxSpeed': item.maxSpeed,
                  'range': item.range
                }),
        _airplaneEntityDeletionAdapter = DeletionAdapter(
            database,
            'AirplaneEntity',
            ['id'],
            (AirplaneEntity item) => <String, Object?>{
                  'id': item.id,
                  'type': item.type,
                  'numberOfPassengers': item.numberOfPassengers,
                  'maxSpeed': item.maxSpeed,
                  'range': item.range
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<AirplaneEntity> _airplaneEntityInsertionAdapter;

  final UpdateAdapter<AirplaneEntity> _airplaneEntityUpdateAdapter;

  final DeletionAdapter<AirplaneEntity> _airplaneEntityDeletionAdapter;

  @override
  Future<List<AirplaneEntity>> findAllAirplanes() async {
    return _queryAdapter.queryList('SELECT * FROM AirplaneEntity',
        mapper: (Map<String, Object?> row) => AirplaneEntity(
            id: row['id'] as int?,
            type: row['type'] as String,
            numberOfPassengers: row['numberOfPassengers'] as int,
            maxSpeed: row['maxSpeed'] as double,
            range: row['range'] as double));
  }

  @override
  Future<AirplaneEntity?> findAirplaneById(int id) async {
    return _queryAdapter.query('SELECT * FROM AirplaneEntity WHERE id = ?1',
        mapper: (Map<String, Object?> row) => AirplaneEntity(
            id: row['id'] as int?,
            type: row['type'] as String,
            numberOfPassengers: row['numberOfPassengers'] as int,
            maxSpeed: row['maxSpeed'] as double,
            range: row['range'] as double),
        arguments: [id]);
  }

  @override
  Future<void> insertAirplane(AirplaneEntity airplane) async {
    await _airplaneEntityInsertionAdapter.insert(
        airplane, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateAirplane(AirplaneEntity airplane) async {
    await _airplaneEntityUpdateAdapter.update(
        airplane, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteAirplane(AirplaneEntity airplane) async {
    await _airplaneEntityDeletionAdapter.delete(airplane);
  }
}

class _$ReservationDao extends ReservationDao {
  _$ReservationDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _reservationInsertionAdapter = InsertionAdapter(
            database,
            'reservations',
            (Reservation item) => <String, Object?>{
                  'customerId': item.customerId,
                  'flightId': item.flightId,
                  'reservationName': item.reservationName,
                  'date': item.date
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Reservation> _reservationInsertionAdapter;

  @override
  Future<List<Reservation>> getAllReservations() async {
    return _queryAdapter.queryList('SELECT * FROM reservations',
        mapper: (Map<String, Object?> row) => Reservation(
            customerId: row['customerId'] as int,
            flightId: row['flightId'] as int,
            reservationName: row['reservationName'] as String,
            date: row['date'] as String));
  }

  @override
  Future<List<Reservation>> getReservationsByCustomerId(int customerId) async {
    return _queryAdapter.queryList(
        'SELECT * FROM reservations WHERE customerId = ?1',
        mapper: (Map<String, Object?> row) => Reservation(
            customerId: row['customerId'] as int,
            flightId: row['flightId'] as int,
            reservationName: row['reservationName'] as String,
            date: row['date'] as String),
        arguments: [customerId]);
  }

  @override
  Future<void> deleteReservation(int id) async {
    await _queryAdapter.queryNoReturn('DELETE FROM reservations WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> insertReservation(Reservation reservation) async {
    await _reservationInsertionAdapter.insert(
        reservation, OnConflictStrategy.replace);
  }
}
