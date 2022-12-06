import 'package:pylons_sdk/pylons_sdk.dart';

class Character {
  late int swordLv;
  late int coins;
  late int shards;
  late int curHp;
  late Item item;

  Character(Item item) {
    item = item;
    swordLv = item.getInt("swordLevel")?.toInt() ?? 0;
    coins = item.getInt("coins")?.toInt() ?? 0;
    shards = item.getInt("shards")?.toInt() ?? 0;
    curHp = item.getInt("currentHp")?.toInt() ?? 0;
  }

  bool isDead() => curHp < 1;
}