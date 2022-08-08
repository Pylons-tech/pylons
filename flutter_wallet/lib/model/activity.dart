enum ActionType {
  actionUnknonwn,
  actionCreateRecipe,
  actionMint,
  actionPurchase,
  // further types
}

extension AccountActionTypeDePar on ActionType {
  String itemToString() {
    final _stringMap = <String, ActionType>{
      'unknown': ActionType.actionUnknonwn,
      'created': ActionType.actionCreateRecipe,
      'minted': ActionType.actionMint,
      'purchased': ActionType.actionPurchase,
    };

    return _stringMap.keys
        .firstWhere((key) => _stringMap[key] == this, orElse: () => 'unknown');
  }
}

extension AccountActionTypePar on String {
  ActionType fromString() {
    final _stringMap = <String, ActionType>{
      'unknown': ActionType.actionUnknonwn,
      'created': ActionType.actionCreateRecipe,
      'minted': ActionType.actionMint,
      'purchased': ActionType.actionPurchase,
    };

    return _stringMap[this] ?? ActionType.actionUnknonwn;
  }
}

class Activity {
  static const db_id = "id";
  static const db_username = "username";
  static const db_action = "action";
  static const db_item_name = "itemname";
  static const db_item_url = "itemurl";
  static const db_item_desc = "itemdesc";
  static const db_item_cookbookid = "cookbookid";
  static const db_item_recipeid = "recipeid";
  static const db_item_id = "itemid";
  static const db_timestamp = "timestamp";

  String username = "";
  String itemName = "";
  String itemUrl = "";
  String itemDesc = "";
  String cookbookID = "";
  String recipeID = "";
  String itemID = "";
  String timestamp = "";
  ActionType action = ActionType.actionUnknonwn;
  int id = 0;

  Activity({
    required this.id,
    required this.username,
    required this.action,
    required this.itemName,
    required this.itemUrl,
    required this.itemDesc,
    required this.cookbookID,
    required this.recipeID,
    required this.itemID,
    required this.timestamp,
  });

  String actionString() {
    return action.itemToString();
  }

  Activity.fromMap(Map<String, dynamic> map)
      : this(
            id: map[db_id] == null ? (map[db_id] as int) : 0,
            username: (map[db_username]).toString(),
            action: map[db_action].toString().fromString(),
            itemName: (map[db_item_name] ?? '').toString(),
            itemUrl: (map[db_item_url] ?? '').toString(),
            itemDesc: (map[db_item_cookbookid] ?? '').toString(),
            cookbookID: (map[db_item_cookbookid] ?? '').toString(),
            recipeID: (map[db_item_recipeid] ?? '').toString(),
            timestamp: (map[db_timestamp] ?? '').toString(),
            itemID: (map[db_timestamp] ?? '').toString());

  Map<String, dynamic> toMap() {
    return {
      db_id: id,
      db_username: username,
      db_action: action,
      db_item_name: itemName,
      db_item_url: itemUrl,
      db_item_desc: itemDesc,
      db_item_cookbookid: cookbookID,
      db_item_recipeid: recipeID,
      db_timestamp: timestamp
    };
  }
}
