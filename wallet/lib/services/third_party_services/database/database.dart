import 'dart:async';

import 'package:floor/floor.dart';
import 'package:pylons_wallet/model/favorites.dart';
import 'package:pylons_wallet/model/transaction_failure_model.dart';
import 'package:pylons_wallet/services/third_party_services/database/dao/tx_manager_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'dao/favorites_dao.dart';

part 'database.g.dart';

@Database(version: 2, entities: [LocalTransactionModel, FavoritesModel])
abstract class AppDatabase extends FloorDatabase {
  TxManagerDao get txManagerDao;

  FavoritesDao get favoritesDao;
}
