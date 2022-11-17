// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$AppDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  /// Adds migrations to the builder.
  _$AppDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$AppDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
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

  TxManagerDao? _txManagerDaoInstance;

  FavoritesDao? _favoritesDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 2,
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
            'CREATE TABLE IF NOT EXISTS `LocalTransactionModel` (`id` INTEGER, `transactionHash` TEXT NOT NULL, `transactionCurrency` TEXT NOT NULL, `transactionPrice` TEXT NOT NULL, `transactionType` TEXT NOT NULL, `transactionData` TEXT NOT NULL, `transactionDescription` TEXT NOT NULL, `status` TEXT NOT NULL, `dateTime` INTEGER NOT NULL, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `FavoritesModel` (`dateTime` INTEGER NOT NULL, `id` TEXT NOT NULL, `cookbookId` TEXT NOT NULL, `type` TEXT NOT NULL, PRIMARY KEY (`dateTime`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TxManagerDao get txManagerDao {
    return _txManagerDaoInstance ??= _$TxManagerDao(database, changeListener);
  }

  @override
  FavoritesDao get favoritesDao {
    return _favoritesDaoInstance ??= _$FavoritesDao(database, changeListener);
  }
}

class _$TxManagerDao extends TxManagerDao {
  _$TxManagerDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _localTransactionModelInsertionAdapter = InsertionAdapter(
            database,
            'LocalTransactionModel',
            (LocalTransactionModel item) => <String, Object?>{
                  'id': item.id,
                  'transactionHash': item.transactionHash,
                  'transactionCurrency': item.transactionCurrency,
                  'transactionPrice': item.transactionPrice,
                  'transactionType': item.transactionType,
                  'transactionData': item.transactionData,
                  'transactionDescription': item.transactionDescription,
                  'status': item.status,
                  'dateTime': item.dateTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<LocalTransactionModel>
      _localTransactionModelInsertionAdapter;

  @override
  Future<List<LocalTransactionModel>> getAllFailuresEntries() async {
    return _queryAdapter.queryList(
        'SELECT * FROM LocalTransactionModel ORDER BY dateTime DESC',
        mapper: (Map<String, Object?> row) => LocalTransactionModel(
            id: row['id'] as int?,
            transactionHash: row['transactionHash'] as String,
            transactionCurrency: row['transactionCurrency'] as String,
            transactionPrice: row['transactionPrice'] as String,
            transactionType: row['transactionType'] as String,
            transactionData: row['transactionData'] as String,
            transactionDescription: row['transactionDescription'] as String,
            dateTime: row['dateTime'] as int,
            status: row['status'] as String));
  }

  @override
  Future<void> delete(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM LocalTransactionModel WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<int> insertTransactionFailure(LocalTransactionModel txManager) {
    return _localTransactionModelInsertionAdapter.insertAndReturnId(
        txManager, OnConflictStrategy.abort);
  }
}

class _$FavoritesDao extends FavoritesDao {
  _$FavoritesDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _favoritesModelInsertionAdapter = InsertionAdapter(
            database,
            'FavoritesModel',
            (FavoritesModel item) => <String, Object?>{
                  'dateTime': item.dateTime,
                  'id': item.id,
                  'cookbookId': item.cookbookId,
                  'type': item.type
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<FavoritesModel> _favoritesModelInsertionAdapter;

  @override
  Future<List<FavoritesModel>> getAll() async {
    return _queryAdapter.queryList(
        'SELECT * FROM FavoritesModel ORDER BY dateTime DESC',
        mapper: (Map<String, Object?> row) => FavoritesModel(
            id: row['id'] as String,
            cookbookId: row['cookbookId'] as String,
            type: row['type'] as String,
            dateTime: row['dateTime'] as int));
  }

  @override
  Future<void> delete(String id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM FavoritesModel WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE  FROM FavoritesModel');
  }

  @override
  Future<int> insertFavorites(FavoritesModel favoritesModel) {
    return _favoritesModelInsertionAdapter.insertAndReturnId(
        favoritesModel, OnConflictStrategy.abort);
  }
}
