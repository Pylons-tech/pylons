<!--
order: 3
-->

# Messages

This section describes the processing of the `pylons` messages and the corresponding updates to the state.

## Accounts

Accounts in `pylons` are a two-way map between a Cosmos SDK address and a username.  

Account creation in Pylons differs from standard Cosmos SDK chains where an account is created automatically and only when an address receives tokens.

Pylons allows for free experiences for accounts that have 0 balance. A manual transaction for account creation is included.

Usernames are enforced to be globally unique and MUST satisfy the following regular expression rule: 

```text
^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$
```

### MsgCreateAccount

```protobuf
message MsgCreateAccount {
  string creator = 1;
  string username = 2;
}
```

The message handling should fail if:
- an account has already been created with the creator address
- the username is already taken by another account

### MsgUpdateAccount


```protobuf
message MsgUpdateAccount {
  string creator = 1;
  string username = 2;
}
```

The message handling should fail if:
- the username is already taken by another account

## Cookbooks

Cookbooks are the "container" object that `Recipe` objects are scoped to.
They specify a collection of recipes with some common relationship or ecosystem.

### MsgCreateCookbook

The `ID` string field MUST satisfy the following regular expression rule: 

```text
^[a-zA-Z_][a-zA-Z_0-9]*$
```

The `name` string field MUST be a minimum of `MinNameFieldLength` characters.

The `description` string field MUST be a minimum of `MinDescriptionFieldLength	` characters.

The `version` string field MUST be a valid Semantic Version string.

The `supportEmail` string field MUST be a valid email address satisfying the following regular expression rule: 

```text
^([a-zA-Z0-9_\-.]+)@([a-zA-Z0-9_\-.]+)\.([a-zA-Z0-9]{2,})$
```

```protobuf
message MsgCreateCookbook {
  string creator = 1;
  string ID = 2;
  string name = 3;
  string description = 4;
  string developer = 5;
  string version = 6;
  string supportEmail = 7;
  bool enabled = 8;
}
```

The message handling should fail if: 
- the value of ID is already taken by another cookbook

### `MsgUpdateCookbook`

When updating a `Cookbook` the following fields may be modified:

- `name`
- `description`
- `developer`
- `version`
- `supportEmail`
- `enabled`

following the established regular expression rule restrictions.

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
  bool enabled = 8;
}
```

The message handling should fail if:
- the cookbook specified by ID is not owned by the message creator address or does not exist
- the version field is incorrectly updated

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

The message handling should fail if:
- the cookbook specified by ID is not owned by the message creator address or does not exist

## Recipes

`Recipe` objects are blueprints for `Execution` objects, specifying inputs (coins and `Item`s) and outputs (coins and `Item`) as well as logic and probabilities for execution.

### `MsgCreateRecipe`

The `cookbookID` string field MUST:

- Point to an existing `Cookbook` that is owned by `Recipe.creator`.
- Satisfy the following regular expression rule:  

```text
^[a-zA-Z_][a-zA-Z_0-9]*$
```

The `ID` string field MUST satisfy the following regex:  

```text
^[a-zA-Z_][a-zA-Z_0-9]*$
```

The `name` string field MUST be a minimum of `MinNameFieldLength` characters.

The `description` string field MUST be a minimum of `MinDescriptionFieldLength	` characters.

The `version` string field MUST be a valid Semantic Version string.

The `blockInterval` field MUST be a non-negative integer.

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
  cosmos.base.v1beta1.Coin costPerBlock = 12 [(gogoproto.nullable) = false];
  bool enabled = 13;
  string extraInfo = 14;
}
```

The message handling should fail if:
- the cookbook specified by cookbookID is not owned by the message creator address
- the value of ID is already taken by another recipe

### `MsgUpdateRecipe`

When a `Recipe` is updated, the following fields can be modified:

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

Updates must follow the established regex restrictions.

The `version` field MUST be greater than the current version. For example, v0.1.1 > v0.1.0.

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
  cosmos.base.v1beta1.Coin costPerBlock = 12 [(gogoproto.nullable) = false];
  bool enabled = 13;
  string extraInfo = 14;
}
```

The message handling should fail if:
- the cookbook specified by cookbookID is not owned by the message creator address
- the recipe specified by ID is not owned by the message creator address
- the version field is incorrectly updated

## Executions

`Execution` objects represent an instance of running the "program" that is specified by a `Recipe`. Execution is essentially a function
taking a specified input (coins and `Item`s) and returning a concrete output (coins and `Item`s) based on its internal logic.  
 
When an `Execution` is created, it is added to the pending list of executions in a Store. Only the validity of the inputs is checked on submission.  Execution and creation of the outputs is deferred until the `EndBlocker` of block #`executionSubmissionHeight + recipe.blockInterval`.

### `MsgExecuteRecipe`

The `cookbookID` string field MUST satisfy the following regular expression rule:  

```text
^[a-zA-Z_][a-zA-Z_0-9]*$
``` 

The `recipeID` string field MUST satisfy the following regular expression rule: 

```text
^[a-zA-Z_][a-zA-Z_0-9]*$
```

The `Recipe` and `Cookbook` specified by `recipeID` and `cookbookID` MUST have the same owner address.

```protobuf
message MsgExecuteRecipe {
  string creator = 1;
  string cookbookID = 2;
  string recipeID = 3;
  uint64 coinInputsIndex = 4;
  repeated string itemIDs = 5 [(gogoproto.nullable) = false];
  repeated PaymentInfo paymentInfos = 6 [(gogoproto.nullable) = false];
}
```

The message handling should fail if:
- the cookbook specified by cookbookID does not exist or is disabled
- the recipe specified by recipeID does not exist or is disabled
- the account of the creator message address does not have sufficient coins to cover the recipe coinInputs
- the items specified by itemIDs do not exist or are not owned by the message creator address
- the itemIDs provided by the message creator address do not [satisfy](https://github.com/Pylons-tech/pylons/blob/e0cc654fed2be191b7d10735a6ef1705cb1996d6/x/pylons/keeper/msg_server_execute_recipe.go#L80) the message itemInputs 

### `MsgCompleteExecutionEarly`

An `Execution` can be completed before block #`executionSubmissionHeight + recipe.blockInterval` by submitting the Tx corresponding to`MsgCompleteExecutionEarly` and paying a fee
of:

```
completeEarlyFee = cookbook.costPerBlock * ((executionSubmissionHeight + recipe.blockInterval) - currentBlockHeightHeight )
```
<!-- describe what follows here, is this output?-->
```protobuf
message MsgCompleteExecutionEarly {
  string creator = 1;
  string ID = 2;
}
```

The message handling should fail if:
- the execution specified by ID does not exist or was not created by the message creator address
- the account of the creator message address does not have sufficient coins to cover `completeEarlyFee`

## Items

`Item`s can be created only by executing a `Recipe` and cannot be created directly with a `Msg`.  Items can, however, have their mutable strings updated or be transferred between accounts.

### `MsgSetItemString`

When modifying an `Item`'s strings, only the fields in its `mutableStrings` field can be mutated. 

The "mutableStrings" are stored as a map with a `field` and a corresponding `value`.

The `cookbookID` string field MUST satisfy the following regular expression rule:  

```text
^[a-zA-Z_][a-zA-Z_0-9]*$
```  

It MUST also point to an existing `Cookbook` that is owned by `Recipe.creator`.

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

The message handling should fail if:
- the item specified by ID is not owned by the message creator address or does not exist

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

The message handling should fail if:
- an item in the items field does not exist or is not owned by the message creator
- an item in the items field is not tradeable
- the account of the creator message address does not have sufficient coins to cover the item transferFees

## Trades

`Trade`s are posted to the blockchain when created.  They can then be queried and "fulfilled" in another Tx.


### `MsgCreateTrade`

Each `cookbookID` string field of the `itemOutputs` field MUST satisfy the following regular expression rule:  

```text
^[a-zA-Z_][a-zA-Z_0-9]*$
```

Each `ID` string field of the `itemOutputs` field MUST be a valid 8 Byte base58 encoded unsigned integer ([encoding logic](https://github.com/Pylons-tech/pylons/blob/a5f1d165c41a3ab120f2997dd465b2685644b331/x/pylons/types/item.go#L14)).

```protobuf
message MsgCreateTrade {
  string creator = 1;
  repeated CoinInput coinInputs = 2 [(gogoproto.nullable) = false];
  repeated ItemInput itemInputs = 3 [(gogoproto.nullable) = false];
  repeated cosmos.base.v1beta1.Coin coinOutputs = 4 [(gogoproto.nullable) = false, (gogoproto.castrepeated) = "github.com/cosmos/cosmos-sdk/v1beta1.Coins"];
  repeated ItemRef itemOutputs = 5 [(gogoproto.nullable) = false];
  string extraInfo = 6;
}
```

The message handling should fail if:
- an item in the itemOutputs field does not exist or is not owned by the message creator
- an item in the itemOutputs field is not tradeable
- an `sdk.Coins` list in the coinInputs field cannot [cover](https://github.com/Pylons-tech/pylons/blob/e0cc654fed2be191b7d10735a6ef1705cb1996d6/x/pylons/keeper/msg_server_trade.go#L36) the fees of the itemOutputs items
- the account of the creator message address does not have sufficient coins to cover the coinOutputs

### `MsgFulfillTrade`

The `ID` string field MUST satisfy the following regular expression rule:

```text
^[a-zA-Z_][a-zA-Z_0-9]*$
```

Each `cookbookID` string field of the `items` field MUST satisfy the following regular expression rule:  

```text
^[a-zA-Z_][a-zA-Z_0-9]*$
```

Each `ID` string field of the `items` field MUST be a valid 8-byte base58-encoded unsigned integer ([encoding logic](https://github.com/Pylons-tech/pylons/blob/a5f1d165c41a3ab120f2997dd465b2685644b331/x/pylons/types/item.go#L14)).


```protobuf
message MsgFulfillTrade {
  string creator = 1;
  uint64 ID = 2;
  uint64 coinInputsIndex = 3;
  repeated ItemRef items = 4 [(gogoproto.nullable) = false];
  repeated PaymentInfo paymentInfos = 5 [(gogoproto.nullable) = false];
}
```

The message handling should fail if:
- the trade specified by ID does not exist
- the coinInputsIndex value is larger than the number of coinInputs to choose from in the trade
- an item from the items field is not owned by the message creator or does not exist
- an item from the items field is not tradeable
- the items provided by the message creator address do not [satisfy](https://github.com/Pylons-tech/pylons/blob/e0cc654fed2be191b7d10735a6ef1705cb1996d6/x/pylons/keeper/msg_server_fulfill_trade.go#L81) the message itemInputs
- the `sdk.Coins` list in the coinOutputs field cannot [cover](https://github.com/Pylons-tech/pylons/blob/e0cc654fed2be191b7d10735a6ef1705cb1996d6/x/pylons/keeper/msg_server_fulfill_trade.go#L94) the fees of all items in the items field
- the selected coinInputs `sdk.Coins` list cannot [cover](https://github.com/Pylons-tech/pylons/blob/e0cc654fed2be191b7d10735a6ef1705cb1996d6/x/pylons/keeper/msg_server_fulfill_trade.go#L116) the fees of all items in the trade itemOutputs

### `MsgCancelTrade`

The `ID` string field MUST satisfy the following regular expression rule:

```text
^[a-zA-Z_][a-zA-Z_0-9]*$
```

```protobuf
message MsgCancelTrade {
  string creator = 1;
  uint64 ID = 2;
}
```

The message handling should fail if:
- the trade specified by ID does not exist or was not created by the message creator

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

The message handling should fail if:
- a Google IAP Order specified by the purchaseToken does not exist
- the Google IAP signature is invalid

### `MsgBurnDebtToken`

```protobuf
message MsgBurnDebtToken {
  string creator = 1;
  RedeemInfo redeemInfo = 2 [(gogoproto.nullable) = false];
}
```

The message handling should fail if:
- The `RedeemInfo` signature is invalid