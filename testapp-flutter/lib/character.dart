import 'package:pylons_sdk/pylons_sdk.dart';
import 'package:fixnum/fixnum.dart';

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

  static Character fromProfile(Profile profile) {
    Character? chr;
    var lastUpdate = Int64.MIN_VALUE;
    for (var item in profile.items) {
      switch (item.getString("entityType")) {
        case "character": {
          chr = Character(item);
          if (!chr.isDead()) {
            if (item.getLastUpdate() > lastUpdate) {
              lastUpdate = item.getLastUpdate();
            }
          }
          break;
        }
      }
    }
    if (chr == null) {
      throw Exception("Character.fromProfile must find a character");
    }
    return chr;
  }
}