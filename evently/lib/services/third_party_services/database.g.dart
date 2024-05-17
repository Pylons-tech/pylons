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

  EventsDao? _eventsDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 6,
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
            'CREATE TABLE IF NOT EXISTS `Events` (`id` INTEGER, `recipeID` TEXT NOT NULL, `eventName` TEXT NOT NULL, `hostName` TEXT NOT NULL, `thumbnail` TEXT NOT NULL, `startDate` TEXT NOT NULL, `endDate` TEXT NOT NULL, `startTime` TEXT NOT NULL, `endTime` TEXT NOT NULL, `location` TEXT NOT NULL, `description` TEXT NOT NULL, `numberOfTickets` TEXT NOT NULL, `price` TEXT NOT NULL, `listOfPerks` TEXT NOT NULL, `isFreeDrops` TEXT NOT NULL, `cookbookID` TEXT NOT NULL, `step` TEXT NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  EventsDao get eventsDao {
    return _eventsDaoInstance ??= _$EventsDao(database, changeListener);
  }
}

class _$EventsDao extends EventsDao {
  _$EventsDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _eventsInsertionAdapter = InsertionAdapter(
            database,
            'Events',
            (Events item) => <String, Object?>{
                  'id': item.id,
                  'recipeID': item.recipeID,
                  'eventName': item.eventName,
                  'hostName': item.hostName,
                  'thumbnail': item.thumbnail,
                  'startDate': item.startDate,
                  'endDate': item.endDate,
                  'startTime': item.startTime,
                  'endTime': item.endTime,
                  'location': item.location,
                  'description': item.description,
                  'numberOfTickets': item.numberOfTickets,
                  'price': item.price,
                  'listOfPerks': item.listOfPerks,
                  'isFreeDrops': item.isFreeDrops,
                  'cookbookID': item.cookbookID,
                  'step': item.step
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<Events> _eventsInsertionAdapter;

  @override
  Future<List<Events>> findAllEvents() async {
    return _queryAdapter.queryList('SELECT * FROM events',
        mapper: (Map<String, Object?> row) => Events(
            id: row['id'] as int?,
            eventName: row['eventName'] as String,
            hostName: row['hostName'] as String,
            thumbnail: row['thumbnail'] as String,
            startDate: row['startDate'] as String,
            endDate: row['endDate'] as String,
            startTime: row['startTime'] as String,
            endTime: row['endTime'] as String,
            location: row['location'] as String,
            description: row['description'] as String,
            listOfPerks: row['listOfPerks'] as String,
            numberOfTickets: row['numberOfTickets'] as String,
            price: row['price'] as String,
            isFreeDrops: row['isFreeDrops'] as String,
            cookbookID: row['cookbookID'] as String,
            recipeID: row['recipeID'] as String,
            step: row['step'] as String));
  }

  @override
  Future<Events?> findEventsById(int id) async {
    return _queryAdapter.query('SELECT * FROM events WHERE id = ?1',
        mapper: (Map<String, Object?> row) => Events(
            id: row['id'] as int?,
            eventName: row['eventName'] as String,
            hostName: row['hostName'] as String,
            thumbnail: row['thumbnail'] as String,
            startDate: row['startDate'] as String,
            endDate: row['endDate'] as String,
            startTime: row['startTime'] as String,
            endTime: row['endTime'] as String,
            location: row['location'] as String,
            description: row['description'] as String,
            listOfPerks: row['listOfPerks'] as String,
            numberOfTickets: row['numberOfTickets'] as String,
            price: row['price'] as String,
            isFreeDrops: row['isFreeDrops'] as String,
            cookbookID: row['cookbookID'] as String,
            recipeID: row['recipeID'] as String,
            step: row['step'] as String),
        arguments: [id]);
  }

  @override
  Future<void> delete(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM events WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> updateNFTFromDetail(
    String startDate,
    String endDate,
    String startTime,
    String endTime,
    String location,
    String description,
    int id,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE events SET startDate = ?1, endDate= ?2, startTime = ?3, endTime = ?4,location = ?5, description = ?6 WHERE id = ?7',
        arguments: [
          startDate,
          endDate,
          startTime,
          endTime,
          location,
          description,
          id
        ]);
  }

  @override
  Future<void> updateNFTFromPerks(
    String listOfPerks,
    int id,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE events SET listOfPerks = ?1 WHERE id = ?2',
        arguments: [listOfPerks, id]);
  }

  @override
  Future<void> updateNFTFromPrice(
    int id,
    String numberOfTickets,
    String price,
    String isFreeDrops,
  ) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE events SET numberOfTickets = ?2, price = ?3, isFreeDrops = ?4   WHERE id = ?1',
        arguments: [id, numberOfTickets, price, isFreeDrops]);
  }

  @override
  Future<int> insertEvents(Events events) {
    return _eventsInsertionAdapter.insertAndReturnId(
        events, OnConflictStrategy.abort);
  }
}
