import 'dart:async';

import 'package:easel_flutter/models/nft.dart';
import 'package:easel_flutter/services/third_party_services/nft_dao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'database.g.dart';

@Database(version: 6, entities: [NFT])
abstract class AppDatabase extends FloorDatabase {
  NftDao get nftDao;
}
