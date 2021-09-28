<!--
order: 1
-->

# Concepts
_Disclaimer: This is work in progress. Mechanisms are susceptible to change._

## NFTs on Pylons: Items

The `Item` type is Pylons' representation of an NFT.  Moving beyond simple NFT representations like ERC-721,
the `Item` provides a variety of fields to describe arbitrary assets whether they be images or in-game items.

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
## Execution

`Item`s are created through `Execution`s.  A full description of how `Item`s come into existence is as follows:
- Bob creates a `Cookbook` object
- Bob creates a `Recipe` object from their `Cookbook`
- Alice *executes* the `Recipe`
- After the `Execution` finalizes, the minted `Item` is in Alice's wallet

For more information on `Item`s and `Execution`s, see the further sections of this spec.

## Fees

Pylons uses a fee model that differs from most Cosmos SDK-based blockchains.  There are no base gas fees on transactions and instead
are custom fee logic implementations only for certain transactions.  This enables certain transactions to occur for free,
allowing for 0-barrier-to-entry experiences for users.

Fees exist on the following transactions:
- Recipe Execution (optional)
- Send Items
- Trades
- Update Account
- Update Item String