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

The definition of a cookbook can be found in [`cookbook.proto`](LINK).

```go
type Cookbook struct {
	Creator      string     `protobuf:"bytes,1,opt,name=creator,proto3" json:"creator,omitempty"`
	ID           string     `protobuf:"bytes,2,opt,name=ID,proto3" json:"ID,omitempty"`
	NodeVersion  string     `protobuf:"bytes,3,opt,name=nodeVersion,proto3" json:"nodeVersion,omitempty"`
	Name         string     `protobuf:"bytes,4,opt,name=name,proto3" json:"name,omitempty"`
	Description  string     `protobuf:"bytes,5,opt,name=description,proto3" json:"description,omitempty"`
	Developer    string     `protobuf:"bytes,6,opt,name=developer,proto3" json:"developer,omitempty"`
	Version      string     `protobuf:"bytes,7,opt,name=version,proto3" json:"version,omitempty"`
	SupportEmail string     `protobuf:"bytes,8,opt,name=supportEmail,proto3" json:"supportEmail,omitempty"`
	CostPerBlock types.Coin `protobuf:"bytes,9,opt,name=costPerBlock,proto3" json:"costPerBlock"`
	Enabled      bool       `protobuf:"varint,10,opt,name=enabled,proto3" json:"enabled,omitempty"`
}
```

## Recipes

Recipe objects are blueprints for digital experiences involving coins and NFT items.  They can deterministically mint an NFT as users are familiar with from
other blockchains experiences like Ethereum, or specify mini-programs to probabilistically result in a variety of outcomes.  The recipe structure contains
fields specifying the rules and logic of a recipe.

The definition of a recipe can be found in [`recipe.proto`](LINK).

```go
type Recipe struct {
	CookbookID    string            `protobuf:"bytes,1,opt,name=cookbookID,proto3" json:"cookbookID,omitempty"`
	ID            string            `protobuf:"bytes,2,opt,name=ID,proto3" json:"ID,omitempty"`
	NodeVersion   string            `protobuf:"bytes,3,opt,name=nodeVersion,proto3" json:"nodeVersion,omitempty"`
	Name          string            `protobuf:"bytes,4,opt,name=name,proto3" json:"name,omitempty"`
	Description   string            `protobuf:"bytes,5,opt,name=description,proto3" json:"description,omitempty"`
	Version       string            `protobuf:"bytes,6,opt,name=version,proto3" json:"version,omitempty"`
	CoinInputs    []CoinInput       `protobuf:"bytes,7,rep,name=coinInputs,proto3" json:"coinInputs"`
	ItemInputs    []ItemInput       `protobuf:"bytes,8,rep,name=itemInputs,proto3" json:"itemInputs"`
	Entries       EntriesList       `protobuf:"bytes,9,opt,name=entries,proto3" json:"entries"`
	Outputs       []WeightedOutputs `protobuf:"bytes,10,rep,name=outputs,proto3" json:"outputs"`
	BlockInterval int64             `protobuf:"varint,11,opt,name=blockInterval,proto3" json:"blockInterval,omitempty"`
	Enabled       bool              `protobuf:"varint,12,opt,name=enabled,proto3" json:"enabled,omitempty"`
	ExtraInfo     string            `protobuf:"bytes,13,opt,name=extraInfo,proto3" json:"extraInfo,omitempty"`
}
```

## Executions

Execution objects are instances created when a user actually runs a recipe.  The data structure contains information about the specific coins, items,
recipe and outputs involved in the execution.

The definition of a recipe can be found in [`execution.proto`](LINK).

```go
type Execution struct {
	Creator             string                                   `protobuf:"bytes,1,opt,name=creator,proto3" json:"creator,omitempty"`
	ID                  string                                   `protobuf:"bytes,2,opt,name=ID,proto3" json:"ID,omitempty"`
	RecipeID            string                                   `protobuf:"bytes,3,opt,name=recipeID,proto3" json:"recipeID,omitempty"`
	CookbookID          string                                   `protobuf:"bytes,4,opt,name=cookbookID,proto3" json:"cookbookID,omitempty"`
	RecipeVersion       string                                   `protobuf:"bytes,5,opt,name=recipeVersion,proto3" json:"recipeVersion,omitempty"`
	NodeVersion         string                                   `protobuf:"bytes,6,opt,name=nodeVersion,proto3" json:"nodeVersion,omitempty"`
	BlockHeight         int64                                    `protobuf:"varint,7,opt,name=blockHeight,proto3" json:"blockHeight,omitempty"`
	ItemInputs          []ItemRecord                             `protobuf:"bytes,8,rep,name=itemInputs,proto3" json:"itemInputs"`
	CoinInputs          github_com_cosmos_cosmos_sdk_types.Coins `protobuf:"bytes,9,rep,name=coinInputs,proto3,castrepeated=github.com/cosmos/cosmos-sdk/types.Coins" json:"coinInputs"`
	CoinOutputs         github_com_cosmos_cosmos_sdk_types.Coins `protobuf:"bytes,10,rep,name=coinOutputs,proto3,castrepeated=github.com/cosmos/cosmos-sdk/types.Coins" json:"coinOutputs"`
	ItemOutputIDs       []string                                 `protobuf:"bytes,11,rep,name=itemOutputIDs,proto3" json:"itemOutputIDs,omitempty"`
	ItemModifyOutputIDs []string                                 `protobuf:"bytes,12,rep,name=itemModifyOutputIDs,proto3" json:"itemModifyOutputIDs,omitempty"`
}
```

## Items

Item objects provide the core asset identity file for the `pylons` module. <!-- need general object description here, what is the file with this code? where does it live in the repo? -->.

The definition of a recipe can be found in [`item.proto`](LINK).


````go
type Item struct {
	Owner          string           `protobuf:"bytes,1,opt,name=owner,proto3" json:"owner,omitempty"`
	CookbookID     string           `protobuf:"bytes,2,opt,name=cookbookID,proto3" json:"cookbookID,omitempty"`
	ID             string           `protobuf:"bytes,3,opt,name=ID,proto3" json:"ID,omitempty"`
	NodeVersion    string           `protobuf:"bytes,4,opt,name=nodeVersion,proto3" json:"nodeVersion,omitempty"`
	Doubles        []DoubleKeyValue `protobuf:"bytes,5,rep,name=doubles,proto3" json:"doubles"`
	Longs          []LongKeyValue   `protobuf:"bytes,6,rep,name=longs,proto3" json:"longs"`
	Strings        []StringKeyValue `protobuf:"bytes,7,rep,name=strings,proto3" json:"strings"`
	MutableStrings []StringKeyValue `protobuf:"bytes,8,rep,name=mutableStrings,proto3" json:"mutableStrings"`
	Tradeable      bool             `protobuf:"varint,9,opt,name=tradeable,proto3" json:"tradeable,omitempty"`
	LastUpdate     int64            `protobuf:"varint,10,opt,name=lastUpdate,proto3" json:"lastUpdate,omitempty"`
	TransferFee    []types.Coin     `protobuf:"bytes,11,rep,name=transferFee,proto3" json:"transferFee"`
	// The percentage of a trade sale retained by the cookbook owner. In the range (0.0, 1.0).
	TradePercentage github_com_cosmos_cosmos_sdk_types.Dec `protobuf:"bytes,12,opt,name=tradePercentage,proto3,customtype=github.com/cosmos/cosmos-sdk/types.Dec" json:"tradePercentage"`
}
````

## Trades

Trades objects are <!-- need general object description here, what is the file with this code? where does it live in the repo? -->.

The definition of a recipe can be found in [`trade.proto`](LINK).


```go
type Trade struct {
	Creator          string                                   `protobuf:"bytes,1,opt,name=creator,proto3" json:"creator,omitempty"`
	ID               uint64                                   `protobuf:"varint,2,opt,name=ID,proto3" json:"ID,omitempty"`
	CoinInputs       []CoinInput                              `protobuf:"bytes,3,rep,name=coinInputs,proto3" json:"coinInputs"`
	ItemInputs       []ItemInput                              `protobuf:"bytes,4,rep,name=itemInputs,proto3" json:"itemInputs"`
	CoinOutputs      github_com_cosmos_cosmos_sdk_types.Coins `protobuf:"bytes,5,rep,name=coinOutputs,proto3,castrepeated=github.com/cosmos/cosmos-sdk/types.Coins" json:"coinOutputs"`
	ItemOutputs      []ItemRef                                `protobuf:"bytes,6,rep,name=itemOutputs,proto3" json:"itemOutputs"`
	ExtraInfo        string                                   `protobuf:"bytes,7,opt,name=extraInfo,proto3" json:"extraInfo,omitempty"`
	Receiver         string                                   `protobuf:"bytes,8,opt,name=receiver,proto3" json:"receiver,omitempty"`
	TradedItemInputs []ItemRef                                `protobuf:"bytes,9,rep,name=tradedItemInputs,proto3" json:"tradedItemInputs"`
}
```

## PylonsAccounts

The PylonsAccounts objects define a two-way map between a Cosmos SDK address and a username.  

  <!-- need general object description here, what is the file with this code? where does it live in the repo? -->.
The definition of a recipe can be found in [`accounts.proto`](LINK).


```go
type UserMap struct {
	AccountAddr string `protobuf:"bytes,1,opt,name=accountAddr,proto3" json:"accountAddr,omitempty"`
	Username    string `protobuf:"bytes,2,opt,name=username,proto3" json:"username,omitempty"`
}
```