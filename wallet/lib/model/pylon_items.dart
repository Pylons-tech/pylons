class PylonItems {
  final String owner;
  final String cookBookId;
  final String id;
  final String nodeVersion;
  final bool tradeAble;
  final String lastUpdate;
  final String tradePercentage;
  final String createdAt;
  final String updatedAt;
  final String recipeId;

  final List<KeyValue> doubles;
  final List<KeyValue> longs;
  final List<KeyValue> Strings;
  final List<DenomAmount> transferAmount;

  PylonItems({
    required this.owner,
    required this.cookBookId,
    required this.id,
    required this.nodeVersion,
    required this.tradeAble,
    required this.lastUpdate,
    required this.tradePercentage,
    required this.createdAt,
    required this.updatedAt,
    required this.recipeId,
    required this.doubles,
    required this.longs,
    required this.Strings,
    required this.transferAmount,
  });

  factory PylonItems.fromJson(Map<String, dynamic> json) {
    final List<KeyValue> doubles = [];

    json["doubles"].map((e) {
      final keyValue = KeyValue.fromJson(e as Map<String, dynamic>);
      doubles.add(keyValue);
    }).toList();

    final List<KeyValue> longs = [];

    json["longs"].map((e) {
      final keyValue = KeyValue.fromJson(e as Map<String, dynamic>);
      longs.add(keyValue);
    }).toList();

    final List<KeyValue> Strings = [];

    json["strings"].map((e) {
      final keyValue = KeyValue.fromJson(e as Map<String, dynamic>);
      Strings.add(keyValue);
    }).toList();

    final List<DenomAmount> transferAmount = [];

    json["transfer_fee"].map((e) {
      final denomAmount = DenomAmount.fromJson(e as Map<String, dynamic>);
      transferAmount.add(denomAmount);
    }).toList();

    return PylonItems(
      owner: json["owner"] as String,
      cookBookId: json["cookbook_id"] as String,
      id: json["id"] as String,
      nodeVersion: json["node_version"] as String,
      tradeAble: json["tradeable"] as bool,
      lastUpdate: json["last_update"] as String,
      tradePercentage: json["trade_percentage"] as String,
      createdAt: json["created_at"] as String,
      updatedAt: json["updated_at"] as String,
      recipeId: json["recipe_id"] as String,
      doubles: doubles.toList(),
      longs: longs.toList(),
      Strings: Strings.toList(),
      transferAmount: transferAmount.toList(),
    );
  }
}

class KeyValue {
  KeyValue({required this.key, required this.value});

  final String key;
  final String value;

  factory KeyValue.fromJson(Map<String, dynamic> json) {
    return KeyValue(key: json["key"] as String, value: json["value"] as String);
  }
}

class DenomAmount {
  final String denom;
  final String amount;

  DenomAmount({required this.denom, required this.amount});

  factory DenomAmount.fromJson(Map<String, dynamic> json) {
    return DenomAmount(denom: json["denom"] as String, amount: json["amount"] as String);
  }
}


class NonEaselItemModel {
  NonEaselItemModel( {
    required this.cookBookId,
    required this.coins,
    required this.currentHp,
    required this.shards,
    required this.swordLevel,
    required this.wins,
    required this.maxHp,
  });

  final String cookBookId;
  final String coins;
  final String currentHp;
  final String shards;
  final String swordLevel;
  final String wins;
  final String maxHp;
}