


class TxResponseJson {
  TxResponseJson({
    required this.txhash,
    required this.tx,
    required this.timestamp,
  });

  factory TxResponseJson.fromJson(Map<String, dynamic> json) => TxResponseJson(
    txhash: json['txhash'] as String? ?? '',
    tx: TxJson.fromJson(json['tx'] as Map<String, dynamic>),
    timestamp: DateTime.parse(json['timestamp'] as String),
  );

  String txhash;
  TxJson tx;
  DateTime timestamp;
}



class TxJson {
  TxJson({
    required this.type,
    required this.body,
  });

  factory TxJson.fromJson(Map<String, dynamic> json) => TxJson(
    type: json['@type'] as String? ?? '',
    body: TxBodyJson.fromJson(json['body'] as Map<String, dynamic>),
  );

  String type;
  TxBodyJson body;
}



class TxBodyJson {
  TxBodyJson({required this.messages});

  factory TxBodyJson.fromJson(Map<String, dynamic> json) => TxBodyJson(
    messages: (json['messages'] as List).map((x) => TxBodyMessageJson.fromJson(x as Map<String, dynamic>)).toList(),
  );

  List<TxBodyMessageJson> messages;
}


class TxBodyMessageJson {
  TxBodyMessageJson({
    required this.type,
    required this.fromAddress,
    required this.toAddress,
    required this.amount,
  });

  factory TxBodyMessageJson.fromJson(Map<String, dynamic> json) {
    return TxBodyMessageJson(
      type: json['@type'] as String? ?? '',
      fromAddress: json['from_address'] as String? ?? '',
      toAddress: json['to_address'] as String? ?? '',
      amount: (json['amount'] as List).map((x) => AmountJson.fromJson(x as Map<String, dynamic>)).toList(),
    );
  }

  String type;
  String fromAddress;
  String toAddress;
  List<AmountJson> amount;
}

class AmountJson {
  AmountJson({
    required this.denom,
    required this.amount,
  });

  factory AmountJson.fromJson(Map<String, dynamic> json) => AmountJson(
    denom: json['denom'] as String? ?? '',
    amount: json['amount'] as String? ?? '',
  );

  String denom;
  String amount;
}
