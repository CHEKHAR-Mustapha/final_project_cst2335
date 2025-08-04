// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flight_list_db.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $FlightDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $FlightDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $FlightDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<FlightDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorFlightDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $FlightDatabaseBuilderContract databaseBuilder(String name) =>
      _$FlightDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $FlightDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$FlightDatabaseBuilder(null);
}

class _$FlightDatabaseBuilder implements $FlightDatabaseBuilderContract {
  _$FlightDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $FlightDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $FlightDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<FlightDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$FlightDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$FlightDatabase extends FlightDatabase {
  _$FlightDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  FlightDao? _flightDaoInstance;

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
            'CREATE TABLE IF NOT EXISTS `FlightEntity` (`id` INTEGER PRIMARY KEY AUTOINCREMENT, `departureCity` TEXT NOT NULL, `arrivalCity` TEXT NOT NULL, `departureTime` INTEGER NOT NULL, `arrivalTime` INTEGER NOT NULL)');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  FlightDao get flightDao {
    return _flightDaoInstance ??= _$FlightDao(database, changeListener);
  }
}

class _$FlightDao extends FlightDao {
  _$FlightDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database, changeListener),
        _flightEntityInsertionAdapter = InsertionAdapter(
            database,
            'FlightEntity',
            (FlightEntity item) => <String, Object?>{
                  'id': item.id,
                  'departureCity': item.departureCity,
                  'arrivalCity': item.arrivalCity,
                  'departureTime': item.departureTime,
                  'arrivalTime': item.arrivalTime
                },
            changeListener),
        _flightEntityUpdateAdapter = UpdateAdapter(
            database,
            'FlightEntity',
            ['id'],
            (FlightEntity item) => <String, Object?>{
                  'id': item.id,
                  'departureCity': item.departureCity,
                  'arrivalCity': item.arrivalCity,
                  'departureTime': item.departureTime,
                  'arrivalTime': item.arrivalTime
                },
            changeListener),
        _flightEntityDeletionAdapter = DeletionAdapter(
            database,
            'FlightEntity',
            ['id'],
            (FlightEntity item) => <String, Object?>{
                  'id': item.id,
                  'departureCity': item.departureCity,
                  'arrivalCity': item.arrivalCity,
                  'departureTime': item.departureTime,
                  'arrivalTime': item.arrivalTime
                },
            changeListener);

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FlightEntity> _flightEntityInsertionAdapter;

  final UpdateAdapter<FlightEntity> _flightEntityUpdateAdapter;

  final DeletionAdapter<FlightEntity> _flightEntityDeletionAdapter;

  @override
  Future<List<FlightEntity>> findAllFlights() async {
    return _queryAdapter.queryList('SELECT * FROM FlightEntity',
        mapper: (Map<String, Object?> row) => FlightEntity(
            row['id'] as int?,
            row['departureCity'] as String,
            row['arrivalCity'] as String,
            row['departureTime'] as int,
            row['arrivalTime'] as int));
  }

  @override
  Stream<FlightEntity?> findFlightById(int id) {
    return _queryAdapter.queryStream('SELECT * FROM FlightEntity WHERE id = ?1',
        mapper: (Map<String, Object?> row) => FlightEntity(
            row['id'] as int?,
            row['departureCity'] as String,
            row['arrivalCity'] as String,
            row['departureTime'] as int,
            row['arrivalTime'] as int),
        arguments: [id],
        queryableName: 'FlightEntity',
        isView: false);
  }

  @override
  Future<void> insertFlight(FlightEntity flight) async {
    await _flightEntityInsertionAdapter.insert(
        flight, OnConflictStrategy.abort);
  }

  @override
  Future<void> updateFlight(FlightEntity flight) async {
    await _flightEntityUpdateAdapter.update(flight, OnConflictStrategy.abort);
  }

  @override
  Future<void> deleteFlight(FlightEntity flight) async {
    await _flightEntityDeletionAdapter.delete(flight);
  }
}
