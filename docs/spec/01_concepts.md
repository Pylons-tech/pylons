<!--
order: 1
-->

# Concepts
_Disclaimer: This is work in progress. Mechanisms are susceptible to change._

An NFT acts like a deed of ownership to a digital item. The Pylons permissionless network for creating and trading virtual assets allows users to freely collect and display their digital assets. 

## NFTs on Pylons

The `Item` type is the pylons representation of an NFT.  

Simple NFT representations are described in the [EIP-721: Non-Fungible Token Standard](https://eips.ethereum.org/EIPS/eip-721) where every NFT is identified by a unique uint256 ID inside the ERC-721 smart contract. 

The `pylons` module moves beyond EIP-721 and uses the `Item` type with a variety of fields to describe arbitrary assets like images or in-game items.

For example:

```go
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
```

## Execution

`Item` types are created through `Execution` transactions. 

An `Item` type is created with this workflow: 

- Bob creates a `Cookbook` object
- Bob creates a `Recipe` object from their `Cookbook`
- Alice *executes* the `Recipe`
- After the `Execution` finalizes, the minted `Item` is in Alice's wallet

## Fees

Pylons uses a fee model that differs from most Cosmos SDK-based blockchains.  There are no base gas fees on transactions. Instead, Pylons uses custom fee logic implementations with fees only for certain transactions.  This fee model enables certain transactions to occur for free to provide a 0-barrier-to-entry experience for users.

Fees always exist on the following transactions:

- Send Items
- Trades
- Update Account
- Update Item String

Fees are optional on the Recipe Execution transaction.