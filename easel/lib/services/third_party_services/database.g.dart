// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

// ignore: avoid_classes_with_only_static_members
// ignore_for_file: library_private_types_in_public_api

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

  NftDao? _nftDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback? callback]) async {
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
            'CREATE TABLE IF NOT EXISTS `NFT` (`id` INTEGER, `url` TEXT NOT NULL, `thumbnailUrl` TEXT NOT NULL, `name` TEXT NOT NULL, `description` TEXT NOT NULL, `denom` TEXT NOT NULL, `price` TEXT NOT NULL, `creator` TEXT NOT NULL, `owner` TEXT NOT NULL, `amountMinted` INTEGER NOT NULL, `quantity` TEXT NOT NULL, `tradePercentage` TEXT NOT NULL, `cookbookID` TEXT NOT NULL, `recipeID` TEXT NOT NULL, `itemID` TEXT NOT NULL, `width` TEXT NOT NULL, `height` TEXT NOT NULL, `appType` TEXT NOT NULL, `tradeID` TEXT NOT NULL, `ownerAddress` TEXT NOT NULL, `step` TEXT NOT NULL, `ibcCoins` TEXT NOT NULL, `isFreeDrop` TEXT NOT NULL, `type` TEXT NOT NULL, `assetType` TEXT NOT NULL, `duration` TEXT NOT NULL, `hashtags` TEXT NOT NULL, `fileName` TEXT NOT NULL, `fileSize` TEXT NOT NULL, `cid` TEXT NOT NULL, `dateTime` INTEGER NOT NULL, `isDialogShown` INTEGER NOT NULL, `isEnabled` INTEGER NOT NULL, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  NftDao get nftDao {
    return _nftDaoInstance ??= _$NftDao(database, changeListener);
  }
}

class _$NftDao extends NftDao {
  _$NftDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _nFTInsertionAdapter = InsertionAdapter(
            database,
            'NFT',
            (NFT item) => <String, Object?>{
                  'id': item.id,
                  'url': item.url,
                  'thumbnailUrl': item.thumbnailUrl,
                  'name': item.name,
                  'description': item.description,
                  'denom': item.denom,
                  'price': item.price,
                  'creator': item.creator,
                  'owner': item.owner,
                  'amountMinted': item.amountMinted,
                  'quantity': item.quantity,
                  'tradePercentage': item.tradePercentage,
                  'cookbookID': item.cookbookID,
                  'recipeID': item.recipeID,
                  'itemID': item.itemID,
                  'width': item.width,
                  'height': item.height,
                  'appType': item.appType,
                  'tradeID': item.tradeID,
                  'ownerAddress': item.ownerAddress,
                  'step': item.step,
                  'ibcCoins': item.ibcCoins,
                  'isFreeDrop': item.isFreeDrop,
                  'type': item.type,
                  'assetType': item.assetType,
                  'duration': item.duration,
                  'hashtags': item.hashtags,
                  'fileName': item.fileName,
                  'fileSize': item.fileSize,
                  'cid': item.cid,
                  'dateTime': item.dateTime,
                  'isDialogShown': item.isDialogShown ? 1 : 0,
                  'isEnabled': item.isEnabled ? 1 : 0
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<NFT> _nFTInsertionAdapter;

  @override
  Future<List<NFT>> findAllNft() async {
    return _queryAdapter.queryList('SELECT * FROM nft ORDER BY dateTime DESC',
        mapper: (Map<String, Object?> row) => NFT(
            id: row['id'] as int?,
            url: row['url'] as String,
            thumbnailUrl: row['thumbnailUrl'] as String,
            name: row['name'] as String,
            description: row['description'] as String,
            denom: row['denom'] as String,
            price: row['price'] as String,
            type: row['type'] as String,
            creator: row['creator'] as String,
            itemID: row['itemID'] as String,
            cookbookID: row['cookbookID'] as String,
            recipeID: row['recipeID'] as String,
            owner: row['owner'] as String,
            width: row['width'] as String,
            isFreeDrop: row['isFreeDrop'] as String,
            height: row['height'] as String,
            tradePercentage: row['tradePercentage'] as String,
            amountMinted: row['amountMinted'] as int,
            quantity: row['quantity'] as String,
            fileSize: row['fileSize'] as String,
            appType: row['appType'] as String,
            ibcCoins: row['ibcCoins'] as String,
            tradeID: row['tradeID'] as String,
            assetType: row['assetType'] as String,
            step: row['step'] as String,
            duration: row['duration'] as String,
            hashtags: row['hashtags'] as String,
            fileName: row['fileName'] as String,
            cid: row['cid'] as String,
            isEnabled: (row['isEnabled'] as int) != 0,
            isDialogShown: (row['isDialogShown'] as int) != 0,
            dateTime: row['dateTime'] as int));
  }

  @override
  Future<NFT?> findNftById(int id) async {
    return _queryAdapter.query('SELECT * FROM nft WHERE id = ?1',
        mapper: (Map<String, Object?> row) => NFT(
            id: row['id'] as int?,
            url: row['url'] as String,
            thumbnailUrl: row['thumbnailUrl'] as String,
            name: row['name'] as String,
            description: row['description'] as String,
            denom: row['denom'] as String,
            price: row['price'] as String,
            type: row['type'] as String,
            creator: row['creator'] as String,
            itemID: row['itemID'] as String,
            cookbookID: row['cookbookID'] as String,
            recipeID: row['recipeID'] as String,
            owner: row['owner'] as String,
            width: row['width'] as String,
            isFreeDrop: row['isFreeDrop'] as String,
            height: row['height'] as String,
            tradePercentage: row['tradePercentage'] as String,
            amountMinted: row['amountMinted'] as int,
            quantity: row['quantity'] as String,
            fileSize: row['fileSize'] as String,
            appType: row['appType'] as String,
            ibcCoins: row['ibcCoins'] as String,
            tradeID: row['tradeID'] as String,
            assetType: row['assetType'] as String,
            step: row['step'] as String,
            duration: row['duration'] as String,
            hashtags: row['hashtags'] as String,
            fileName: row['fileName'] as String,
            cid: row['cid'] as String,
            isEnabled: (row['isEnabled'] as int) != 0,
            isDialogShown: (row['isDialogShown'] as int) != 0,
            dateTime: row['dateTime'] as int),
        arguments: [id]);
  }

  @override
  Future<void> delete(int id) async {
    await _queryAdapter
        .queryNoReturn('DELETE FROM nft WHERE id = ?1', arguments: [id]);
  }

  @override
  Future<void> updateNFTFromDescription(
      int id,
      String nftName,
      String nftDescription,
      String creatorName,
      String step,
      String hashtags,
      int dateTime) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE nft SET name = ?2, description= ?3, creator = ?4, step = ?5,hashtags = ?6, dateTime = ?7 WHERE id = ?1',
        arguments: [
          id,
          nftName,
          nftDescription,
          creatorName,
          step,
          hashtags,
          dateTime
        ]);
  }

  @override
  Future<void> updateNFTDialogShown(int id) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE nft SET isDialogShown = true WHERE id = ?1',
        arguments: [id]);
  }

  @override
  Future<void> updateNFTFromPrice(
      int id,
      String tradePercentage,
      String price,
      String quantity,
      String step,
      String denom,
      String isFreeDrop,
      int dateTime) async {
    await _queryAdapter.queryNoReturn(
        'UPDATE nft SET tradePercentage = ?2, price= ?3, quantity = ?4, denom =?6, step = ?5, isFreeDrop = ?7, dateTime = ?8 WHERE id = ?1',
        arguments: [
          id,
          tradePercentage,
          price,
          quantity,
          step,
          denom,
          isFreeDrop,
          dateTime
        ]);
  }

  @override
  Future<int> insertNft(NFT nft) {
    return _nFTInsertionAdapter.insertAndReturnId(
        nft, OnConflictStrategy.abort);
  }
}
