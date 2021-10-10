<!--
order: 4
-->

# Events

The `pylons`  module emits Cosmos SDK `TypedEvent`s in the form of proto messages to provide state updates for applications like block explorers.

The `pylons` module emits the following events:

## EventCreateAccount

Emitted when a PylonsAccount is successfully created.
```protobuf
message EventCreateAccount {
  string address = 1;
  string username = 2;
}
```

## EventUpdateAccount

Emitted when a PylonsAccount is successfully updated.
```protobuf
message EventUpdateAccount {
  string address = 1;
  string username = 2;
}
```

## EventCreateCookbook

Emitted when a `Cookbook` is successfully created.
```protobuf
message EventCreateCookbook {
  string creator = 1;
  string ID = 2;
}
```

## EventUpdateCookbook

Emitted when a `Cookbook` is successfully updated.  Message contains the `Cookbook` data before updating for archiving purposes.
```protobuf
message EventUpdateCookbook {
  Cookbook originalCookbook = 1 [(gogoproto.nullable) = false];
}
```

## EventTransferCookbook

Emitted when a `Cookbook` is successfully transferred between two addresses.
```protobuf
message EventTransferCookbook {
  string sender = 1;
  string receiver = 2;
  string ID = 3;
}
```

## EventCreateRecipe

Emitted when a `Recipe` is successfully created.
```protobuf
message EventCreateRecipe {
  string creator = 1;
  string CookbookID = 2;
  string ID = 3;
}
```

## EventUpdateRecipe

Emitted when a `Recipe` is successfully updated.  Message contains the `Recipe` data before updating for archiving purposes.
```protobuf
message EventUpdateRecipe {
  Recipe originalRecipe = 1 [(gogoproto.nullable) = false];
}

```

## EventCreateExecution

Emitted when an `Execution` is successfully submitted.
```protobuf
message EventCreateExecution {
  string creator = 1;
  string ID = 2;
}
```

## EventCompleteExecution

Emitted when an `Execution` is successfully completed.  Contains extra information since execution outcome is not predictable until completion.
```protobuf
message EventCompleteExecution {
  string creator = 1;
  string ID = 2;
  repeated cosmos.base.v1beta1.Coin burnCoins = 3 [(gogoproto.nullable) = false, (gogoproto.castrepeated) = "github.com/cosmos/cosmos-sdk/types.Coins"];
  repeated cosmos.base.v1beta1.Coin payCoins = 4 [(gogoproto.nullable) = false, (gogoproto.castrepeated) = "github.com/cosmos/cosmos-sdk/types.Coins"];
  repeated cosmos.base.v1beta1.Coin transferCoins = 5 [(gogoproto.nullable) = false, (gogoproto.castrepeated) = "github.com/cosmos/cosmos-sdk/types.Coins"];
  repeated cosmos.base.v1beta1.Coin feeCoins = 6 [(gogoproto.nullable) = false, (gogoproto.castrepeated) = "github.com/cosmos/cosmos-sdk/types.Coins"];
  repeated cosmos.base.v1beta1.Coin coinOutputs = 7 [(gogoproto.nullable) = false, (gogoproto.castrepeated) = "github.com/cosmos/cosmos-sdk/types.Coins"];
  repeated Item mintItems = 8 [(gogoproto.nullable) = false];
  repeated Item modifyItems = 9 [(gogoproto.nullable) = false];
}
```

## EventDropExecution

Emitted when an `Execution` is dropped.  This indicates that the `Execution` could not be completed and was abandoned.
```protobuf
message EventDropExecution {
  string creator = 1;
  string ID = 2;
}
```

## EventCompleteExecutionEarly

Emitted when an `Execution` is pushed to be executed immediately using the MsgCompleteExecutionEarly Tx.  The `Execution` still must be finalized, so it can either become "dropped" or "completed".
```protobuf
message EventCompleteExecutionEarly {
  string creator = 1;
  string ID = 2;
}
```

## EventSendItems

Emitted when a `SendItems` Tx is successfully completed.
```protobuf
message EventSendItems {
  string sender = 1;
  string receiver = 2;
  repeated ItemRef items = 3 [(gogoproto.nullable) = false];
}
```

## EventSetItemString

Emitted when MutableStrings fields are updated on an `Item`.  Message contains the original MutableStrings fields for archival purposes.
```protobuf
message EventSetItemString {
  string creator = 1;
  string CookbookID = 2;
  string ID = 3;
  repeated StringKeyValue originalMutableStrings = 4 [(gogoproto.nullable) = false];
}
```

## EventCreateTrade

Emitted when a `Trade` is successfully created.
```protobuf
message EventCreateTrade {
  string creator = 1;
  uint64 ID = 2;
```

## EventCancelTrade

Emitted when a `Trade` is canceled
```protobuf
message EventCancelTrade {
  string creator = 1;
  uint64 ID = 2;
}
```

## EventFulfillTrade

Emitted when a `Trade` is completed.
```protobuf
message EventFulfillTrade {
  uint64 ID = 1;
  string creator = 2;
  string fulfiller = 3;
  repeated ItemRef itemInputs = 4 [(gogoproto.nullable) = false];
  repeated cosmos.base.v1beta1.Coin coinInputs = 5 [(gogoproto.nullable) = false, (gogoproto.castrepeated) = "github.com/cosmos/cosmos-sdk/types.Coins"];
  repeated ItemRef itemOutputs = 6 [(gogoproto.nullable) = false];
  repeated cosmos.base.v1beta1.Coin coinOutputs = 7 [(gogoproto.nullable) = false, (gogoproto.castrepeated) = "github.com/cosmos/cosmos-sdk/types.Coins"];
}
```

## EventGooglePurchase

Emitted when a Google IAP Purchase is completed.
```protobuf
message EventGooglePurchase {
  string creator = 1;
  string productID = 2;
  string purchaseToken = 3;
  string receiptDataBase64 = 4;
  string signature = 5;
}
```

## EventStripePurchase

Emitted when a Stripe purchase is completed.
```protobuf
message EventStripePurchase {
  string creator = 1;
  string ID = 2;
}
```