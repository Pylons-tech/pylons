<!--
order: 2
-->

# State

The `pylons` module tracks the state of these primary objects: 

- Cookbooks
- Recipes
- Executions, pending and completed
- Items
- Trades
- PylonsAccounts

## Cookbooks

Cookbooks objects are containers for recipes.  A cookbook could be a collection of recipes that make up a game experience or be a portfolio of recipes an artist uses to mint their NFTs from.

The definition of a cookbook can be found in [`cookbook.proto`](../../../proto/pylons/cookbook.proto).

```protobuf
message Cookbook {
  string creator = 1;
  string ID = 2;
  uint64 nodeVersion = 3;
  string name = 4;
  string description = 5;
  string developer = 6;
  string version = 7;
  string supportEmail = 8;
  bool enabled = 9;
}
```

## Recipes

Recipe objects are blueprints for digital experiences involving coins and NFT items.  They can deterministically mint an NFT as users are familiar with from
other blockchains experiences like Ethereum, or specify mini-programs to probabilistically result in a variety of outcomes.  The recipe structure contains
fields specifying the rules and logic of a recipe.

The definition of a recipe can be found in [`recipe.proto`](../../../proto/pylons/recipe.proto).

```protobuf
message Recipe {
  string cookbookID = 1;
  string ID = 2;
  uint64 nodeVersion = 3;
  string name = 4;
  string description = 5;
  string version = 6;
  repeated CoinInput coinInputs = 7 [(gogoproto.nullable) = false];
  repeated ItemInput itemInputs = 8 [(gogoproto.nullable) = false];
  EntriesList entries = 9 [(gogoproto.nullable) = false];
  repeated WeightedOutputs outputs = 10 [(gogoproto.nullable) = false];
  int64 blockInterval = 11;
  cosmos.base.v1beta1.Coin costPerBlock = 12 [(gogoproto.nullable) = false];
  bool enabled = 13;
  string extraInfo = 14;
}
```

## Executions

Execution objects are instances created when a user actually runs a recipe.  The data structure contains information about the specific coins, items,
recipe and outputs involved in the execution.

The definition of an execution can be found in [`execution.proto`](../../../proto/pylons/execution.proto).

```protobuf
message Execution {
  string creator = 1;
  string ID = 2;
  string recipeID = 3;
  string cookbookID = 4;
  string recipeVersion = 5;
  uint64 nodeVersion = 6;
  int64 blockHeight = 7;
  repeated ItemRecord itemInputs = 8 [(gogoproto.nullable) = false];
  repeated cosmos.base.v1beta1.Coin coinInputs = 9 [(gogoproto.nullable) = false, (gogoproto.castrepeated) = "github.com/cosmos/cosmos-sdk/v1beta1.Coins"];
  repeated cosmos.base.v1beta1.Coin coinOutputs = 10 [(gogoproto.nullable) = false, (gogoproto.castrepeated) = "github.com/cosmos/cosmos-sdk/v1beta1.Coins"];
  repeated string itemOutputIDs = 11 [(gogoproto.nullable) = false];
  repeated string itemModifyOutputIDs = 12 [(gogoproto.nullable) = false];
}
```

## Items

Item objects provide the core asset identity file for the `pylons` module.  Like ERC-721 NFTs, they contain a unique identifier.  They also contain on-chain data that is set by executing the recipe that mints or modifies the item.

The definition of an item can be found in [`item.proto`](../../../proto/pylons/item.proto).


````protobuf
message Item {
  string owner = 1;
  string cookbookID = 2;
  string ID = 3;
  uint64 nodeVersion = 4;
  repeated DoubleKeyValue doubles = 5 [(gogoproto.nullable) = false];
  repeated LongKeyValue longs = 6 [(gogoproto.nullable) = false];
  repeated StringKeyValue strings = 7 [(gogoproto.nullable) = false];
  repeated StringKeyValue mutableStrings = 8 [(gogoproto.nullable) = false];
  bool tradeable = 9;
  int64 lastUpdate = 10;
  repeated cosmos.base.v1beta1.Coin transferFee = 11 [(gogoproto.nullable) = false];
  // The percentage of a trade sale retained by the cookbook owner. In the range (0.0, 1.0).
  string tradePercentage = 12 [(gogoproto.nullable) = false,(gogoproto.customtype) = "cosmossdk.io/math.Int"];
}
````

## Trades

Trades objects are pushed to the blockchain to be publicly viewed by all users.  Users can then choose to "fulfill" then trade, completing it.

The definition of a trade can be found in [`trade.proto`](../../../proto/pylons/trade.proto).


```protobuf
message Trade {
  string creator = 1;
  uint64 ID = 2;
  repeated CoinInput coinInputs = 3 [(gogoproto.nullable) = false];
  repeated ItemInput itemInputs = 4 [(gogoproto.nullable) = false];
  repeated cosmos.base.v1beta1.Coin coinOutputs = 5 [(gogoproto.nullable) = false, (gogoproto.castrepeated) = "github.com/cosmos/cosmos-sdk/v1beta1.Coins"];
  repeated ItemRef itemOutputs = 6 [(gogoproto.nullable) = false];
  string extraInfo = 7;
  string receiver = 8;
  repeated ItemRef tradedItemInputs = 9 [(gogoproto.nullable) = false];
}
```

## PylonsAccounts

The PylonsAccounts objects define a two-way map between a Cosmos SDK address and a username.  

The definition of the account map can be found in [`accounts.proto`](../../../proto/pylons/accounts.proto).


```protobuf
message UserMap {
  string accountAddr = 1;
  string username = 2;
}
```

## PaymentInfo

The definition of payment info can be found in [`payment_info.proto`](../../../proto/pylons/payment_info.proto).

```protobuf
message PaymentInfo {
  string purchaseID = 1;
  string processorName = 2;
  string payerAddr = 3;
  string amount = 4 [(gogoproto.nullable) = false, (gogoproto.customtype) = "github.com/cosmos/cosmos-sdk/v1beta1.Int"];
  string productID = 5;
  string signature = 6;
}
```

## RedeemInfo

The definition of a redeem info can be found in [`redeem_info.proto`](../../../proto/pylons/redeem_info.proto).

```protobuf
message RedeemInfo {
  string ID = 1;
  string processorName = 2;
  string address = 3;
  string amount = 4 [(gogoproto.nullable) = false, (gogoproto.customtype) = "github.com/cosmos/cosmos-sdk/v1beta1.Int"];;
  string signature = 5;
}
```