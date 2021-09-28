<!--
order: 3
-->

# Messages

## Accounts

Accounts in `pylons` are a two-way map between a Cosmos SDK address and a username.  
Account creation differs from standard Cosmos SDK chains where an account is created automatically and only when an address receives tokens.
Pylons aims to allow for free experiences where accounts can have 0 balance, so a manual Tx for account creation is included.

Usernames are enforced to be globally unique and MUST satisfy the following regex: `^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$`.

### `MsgCreateAccount`
```protobuf
message MsgCreateAccount {
  string creator = 1;
  string username = 2;
}
```

### `MsgUpdateAccount`
```protobuf
message MsgUpdateAccount {
  string creator = 1;
  string username = 2;
}
```

## Cookbooks

Cookbooks are the "container" object that `Recipe` objects are scoped to.
They specify a collection of recipes with some common relationship or ecosystem.

### `MsgCreateCookbook`


The `ID` string field MUST satisfy the following regex:  `^[a-zA-Z_][a-zA-Z_0-9]*$`.

The `name` string field MUST be a minimum of `MinNameFieldLength` characters.

The `description` string field MUST be a minimum of `MinDescriptionFieldLength	` characters.

The `version` string field MUST be a valid Semantic Version string.

The `supportEmail` string field MUST be a valid email address satisfying the following regex: `^([a-zA-Z0-9_\-.]+)@([a-zA-Z0-9_\-.]+)\.([a-zA-Z0-9]{2,})$`.

```protobuf
message MsgCreateCookbook {
  string creator = 1;
  string ID = 2;
  string name = 3;
  string description = 4;
  string developer = 5;
  string version = 6;
  string supportEmail = 7;
  cosmos.base.v1beta1.Coin costPerBlock = 8 [(gogoproto.nullable) = false];
  bool enabled = 9;
}
```

### `MsgUpdateCookbook`


When updating a `Cookbook` the following fields may be modified:
- `name`
- `description`
- `developer`
- `version`
- `supportEmail`
- `costPerBlock`
- `enabled`

following the established regex restrictions.

The `version` field MUST be greater than the current version when updating (ex. v0.1.1 > v0.1.0).

```protobuf
message MsgUpdateCookbook {
  string creator = 1;
  string ID = 2;
  string name = 3;
  string description = 4;
  string developer = 5;
  string version = 6;
  string supportEmail = 7;
  cosmos.base.v1beta1.Coin costPerBlock = 8 [(gogoproto.nullable) = false];
  bool enabled = 9;
}
```

`Cookbook`s may also be transferred.  The `recipient` of the transfer will become the new `Cookbook` owner 
and will therefore control the creation of new `Recipe`s and collect future fees from executions and transfers.

### `MsgTransferCookbook`

The `receiver` string field MUST be a valid Cosmos SDK address with the "pylo" prefix.

```protobuf
message MsgTransferCookbook {
  string creator = 1;
  string ID = 2;
  string recipient = 3;
}
```

## Recipes

`Recipe`s are blueprints for `Execution`s, specifying inputs (coins and `Item`s) and outputs (coins and `Item`s) 
as well as logic and probabilities for execution.

### `MsgCreateRecipe`


The `cookbookID` string field MUST satisfy the following regex:  `^[a-zA-Z_][a-zA-Z_0-9]*$`.  It MUST also point to an existing `Cookbook` that is owned by `Recipe.creator`.

The `ID` string field MUST satisfy the following regex:  `^[a-zA-Z_][a-zA-Z_0-9]*$`.

The `name` string field MUST be a minimum of `MinNameFieldLength` characters.

The `description` string field MUST be a minimum of `MinDescriptionFieldLength	` characters.

The `version` string field MUST be a valid Semantic Version string.

`blockInterval` MUST be a non-negative integer.

```protobuf
message MsgCreateRecipe {
  string creator = 1;
  string cookbookID = 2;
  string ID = 3;
  string name = 4;
  string description = 5;
  string version = 6;
  repeated CoinInput coinInputs = 7 [(gogoproto.nullable) = false];
  repeated ItemInput itemInputs = 8 [(gogoproto.nullable) = false];
  EntriesList entries = 9 [(gogoproto.nullable) = false];
  repeated WeightedOutputs outputs = 10 [(gogoproto.nullable) = false];
  int64 blockInterval = 11;
  bool enabled = 12;
  string extraInfo = 13;
}
```

### `MsgUpdateRecipe`

When updating a `Recipe` the following fields may be modified:
- `name`
- `description`
- `developer`
- `version`
- `coinInputs`
- `itemInputs`
- `entries`
- `outputs`
- `enabled`
- `extraInfo`

following the established regex restrictions.

The `version` field MUST be greater than the current version when updating (ex. v0.1.1 > v0.1.0).

```protobuf
message MsgUpdateRecipe {
  string creator = 1;
  string cookbookID = 2;
  string ID = 3;
  string name = 4;
  string description = 5;
  string version = 6;
  repeated CoinInput coinInputs = 7 [(gogoproto.nullable) = false];
  repeated ItemInput itemInputs = 8 [(gogoproto.nullable) = false];
  EntriesList entries = 9 [(gogoproto.nullable) = false];
  repeated WeightedOutputs outputs = 10 [(gogoproto.nullable) = false];
  int64 blockInterval = 11;
  bool enabled = 12;
  string extraInfo = 13;
}
```

## Executions

`Execution`s represent an instance of running the "program" specified by a `Recipe`.  It is essentially a function
taking a specified input (coins and `Item`s) and returning a concrete output (coins and `Item`s) based on its 
internal logic.  
 
When an `Execution` is created, it is added to the pending list of executions in a Store.  Only the validity of the inputs
is checked upon submission.  Execution and creation of the outputs is deferred until the `EndBlocker`
of block #`executionSubmissionHeight + recipe.blockInterval`.

### `MsgExecuteRecipe`

The `cookbookID` string field MUST satisfy the following regex:  `^[a-zA-Z_][a-zA-Z_0-9]*$`. 

The `recipeID` string field MUST satisfy the following regex:  `^[a-zA-Z_][a-zA-Z_0-9]*$`.

The `Recipe` and `Cookbook` specified by `recipeID` and `cookbookID` MUST have the same owner address.

```protobuf
message MsgExecuteRecipe {
  string creator = 1;
  string cookbookID = 2;
  string recipeID = 3;
  uint64 coinInputsIndex = 4;
  repeated string itemIDs = 5 [(gogoproto.nullable) = false];
}
```

### `MsgCompleteExecutionEarly`

An `Execution` can be completed before block #`executionSubmissionHeight + recipe.blockInterval` by submitting the Tx corresponding to`MsgCompleteExecutionEarly` and paying a fee
of:

```
cookbook.costPerBlock * ((executionSubmissionHeight + recipe.blockInterval) - currentBlockHeightHeight )
```

```protobuf
message MsgCompleteExecutionEarly {
  string creator = 1;
  string ID = 2;
}
```

## Items

`Item`s can only be created by executing a `Recipe` so they cannot be created directly with a `Msg`.  They can, however, have
their mutable strings update or be transferred between accounts.

### `MsgSetItemString`

When modifying an `Item`'s strings, only the fields in its "mutableStrings" field may be mutated.  
The "mutableStrings" are stored as a map with a `field` and a corresponding `value`.

The `cookbookID` string field MUST satisfy the following regex:  `^[a-zA-Z_][a-zA-Z_0-9]*$`.  It MUST also point to an existing `Cookbook` that is owned by `Recipe.creator`.

The `ID` string field MUST be a valid 8 Byte base58 encoded unsigned integer ([encoding logic](https://github.com/Pylons-tech/pylons/blob/a5f1d165c41a3ab120f2997dd465b2685644b331/x/pylons/types/item.go#L14)).  

```protobuf
message MsgSetItemString {
  string creator = 1;
  string cookbookID = 2;
  string ID = 4;
  string field = 5;
  string value = 6;
}
```

### `MsgSendItems`

Items can be sent from one account to another using the following `Msg` if the `creator` has enough balance to cover
all of the `item.transferFee` fields of each specified `Item`.

The `reciever` string field MUST be a valid Cosmos SDK address with the "pylo" prefix.

```protobuf
message MsgSendItems {
  string creator = 1;
  string receiver = 2;
  repeated ItemRef items = 3 [(gogoproto.nullable) = false];
}
```

## Trades

`Trade`s are posted to the blockchain when created.  They can then be queried and "fulfilled" in another Tx.


### `MsgCreateTrade`

Each `cookbookID` string field of the `itemOutputs` field MUST satisfy the following regex:  `^[a-zA-Z_][a-zA-Z_0-9]*$`.

Each `ID` string field of the `itemOutputs` field MUST be a valid 8 Byte base58 encoded unsigned integer ([encoding logic](https://github.com/Pylons-tech/pylons/blob/a5f1d165c41a3ab120f2997dd465b2685644b331/x/pylons/types/item.go#L14)).

```protobuf
message MsgCreateTrade {
  string creator = 1;
  repeated CoinInput coinInputs = 2 [(gogoproto.nullable) = false];
  repeated ItemInput itemInputs = 3 [(gogoproto.nullable) = false];
  repeated cosmos.base.v1beta1.Coin coinOutputs = 4 [(gogoproto.nullable) = false, (gogoproto.castrepeated) = "github.com/cosmos/cosmos-sdk/types.Coins"];
  repeated ItemRef itemOutputs = 5 [(gogoproto.nullable) = false];
  string extraInfo = 6;
}
```

### `MsgFulfillTrade`

The `ID` string field MUST satisfy the following regex:  `^[a-zA-Z_][a-zA-Z_0-9]*$`.

Each `cookbookID` string field of the `items` field MUST satisfy the following regex:  `^[a-zA-Z_][a-zA-Z_0-9]*$`.

Each `ID` string field of the `items` field MUST be a valid 8 Byte base58 encoded unsigned integer ([encoding logic](https://github.com/Pylons-tech/pylons/blob/a5f1d165c41a3ab120f2997dd465b2685644b331/x/pylons/types/item.go#L14)).


```protobuf
message MsgFulfillTrade {
  string creator = 1;
  uint64 ID = 2;
  uint64 coinInputsIndex = 3;
  repeated ItemRef items = 4 [(gogoproto.nullable) = false];
}
```

### `MsgCancelTrade`

The `ID` string field MUST satisfy the following regex:  `^[a-zA-Z_][a-zA-Z_0-9]*$`.

```protobuf
message MsgCancelTrade {
  string creator = 1;
  uint64 ID = 2;
}
```


## Purchases

### `MsgGoogleInAppPurchaseGetCoins`


```protobuf
message MsgGoogleInAppPurchaseGetCoins {
  string creator = 1;
  string productID = 2;
  string purchaseToken = 3;
  string receiptDataBase64 = 4;
  string signature = 5;
}
```

<!--
TODO add stripe
-->