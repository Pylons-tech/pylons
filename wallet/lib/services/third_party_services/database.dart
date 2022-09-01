import 'dart:async';
import 'package:floor/floor.dart';
import 'package:pylons_wallet/model/transaction_failure_model.dart';
import 'package:pylons_wallet/services/third_party_services/tx_manager_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 1, entities: [TransactionManager])
abstract class AppDatabase extends FloorDatabase {
  TxManagerDao get txManagerDao;
}
