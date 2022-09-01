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

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
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
            'CREATE TABLE IF NOT EXISTS `TransactionManager` (`id` INTEGER, `transactionType` TEXT NOT NULL, `transactionErrorCode` TEXT NOT NULL, `transactionData` TEXT NOT NULL, `transactionDescription` TEXT NOT NULL, `dateTime` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  TxManagerDao get txManagerDao {
    return _txManagerDaoInstance ??= _$TxManagerDao(database, changeListener);
  }
}

class _$TxManagerDao extends TxManagerDao {
  _$TxManagerDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _transactionManagerInsertionAdapter = InsertionAdapter(
            database,
            'TransactionManager',
            (TransactionManager item) => <String, Object?>{
                  'id': item.id,
                  'transactionType': item.transactionType,
                  'transactionErrorCode': item.transactionErrorCode,
                  'transactionData': item.transactionData,
                  'transactionDescription': item.transactionDescription,
                  'dateTime': item.dateTime
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<TransactionManager>
      _transactionManagerInsertionAdapter;

  @override
  Future<List<TransactionManager>> getAllFailuresEntries() async {
    return _queryAdapter.queryList(
        'SELECT * FROM TransactionManager ORDER BY dateTime DESC',
        mapper: (Map<String, Object?> row) => TransactionManager(
            id: row['id'] as int?,
            transactionType: row['transactionType'] as String,
            transactionErrorCode: row['transactionErrorCode'] as String,
            transactionData: row['transactionData'] as String,
            transactionDescription: row['transactionDescription'] as String,
            dateTime: row['dateTime'] as int));
  }

  @override
  Future<void> delete(int id) async {
    await _queryAdapter.queryNoReturn(
        'DELETE FROM TransactionManager WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<int> insertTransactionFailure(TransactionManager txManager) {
    return _transactionManagerInsertionAdapter.insertAndReturnId(
        txManager, OnConflictStrategy.abort);
  }
}
