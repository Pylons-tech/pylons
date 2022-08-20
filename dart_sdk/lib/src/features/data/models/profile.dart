/// Types and functionality for dealing with profiles.
library pylons_flutter_profile;

import 'package:equatable/equatable.dart';
import 'package:pylons_sdk/src/generated/pylons/item.pb.dart';
import 'package:decimal/decimal.dart';

/// Object representing a user profile that exists on a Pylons blockchain.
///
/// Note that the SDK-provided profile type does not directly mirror any type that exists on chain.
/// Multiple queries must be made to compose one of these objects. This is not normally relevant to
/// client applications, but may matter if you're trying to do anything too low-level.

class Profile extends Equatable {
  final String address;
  final String username;
  final bool stripeExists;
  final List<Balance> coins;
  final List<Item> items;
  final List<String> supportedCoins;

  Profile(
      {required this.address,
      required this.username,
      required this.coins,
      required this.stripeExists,
      required this.supportedCoins,
      required this.items});

  Map<String, dynamic> toJson() => {
        'address': address,
        'username': username,
        'stripeExists': stripeExists,
        'coins': coins.map((Balance balance) => balance.toJson()).toList(),
        'items': items.map((Item item) => item.toProto3Json()).toList(),
        'supportedCoins':
            supportedCoins.map((supportedCoin) => supportedCoin).toList()
      };

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      coins: List.from(json['coins'])
          .map((coin) => Balance.fromJSON(coin))
          .toList(),
      address: json['address'],
      username: json['username'],
      items: List.from(json['items'])
          .map((item) => Item.create()..mergeFromProto3Json(item))
          .toList(),
      stripeExists: json['stripeExists'],
      supportedCoins: List<String>.from(json['supportedCoins']),
    );
  }

  factory Profile.initial() {
    return Profile(
        items: [],
        username: '',
        coins: [],
        stripeExists: false,
        address: '',
        supportedCoins: []);
  }

  @override
  String toString() {
    return 'Profile{address: $address, username: $username, stripeExists: $stripeExists, coins: $coins, items: $items, supportedCoins: $supportedCoins}';
  }

  @override
  List<Object?> get props => [
        address,
        username,
        stripeExists,
        coins,
        items,
        supportedCoins,
      ];
}

class Balance extends Equatable {
  final String denom;
  final Amount amount;

  const Balance({
    required this.denom,
    required this.amount,
  });

  Balance.fromJSON(Map<String, dynamic> json)
      : denom = json['denom'] as String,
        amount = Amount.fromString(json['amount'] as String);

  @override
  String toString() => '$amount $denom';

  @override
  List<Object> get props => [
        denom,
        amount,
      ];

  Map<String, dynamic> toJson() => {'denom': denom, 'amount': amount};
}

class Amount {
  final Decimal value;

  Amount(this.value);

  Amount.fromString(String string) : value = Decimal.parse(string);

  Amount.fromInt(int int) : value = Decimal.fromInt(int);

  @override
  String toString() => value.toStringAsPrecision(10);

  String get displayText => value.toStringAsPrecision(10);
}

extension StringAmount on String {
  Amount get amount => Amount.fromString(this);
}

extension IntAmount on int {
  Amount get amount => Amount.fromInt(this);
}

extension AmountValue on Amount {
  Decimal toHumanReadable() {
    return (value / Decimal.fromInt(1000000)).toDecimal();
  }
}
