package v046

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	v1 "github.com/Pylons-tech/pylons/x/pylons/types/v1"
)

// ConvertToLegacyProposal takes a new proposal and attempts to convert it to the
// legacy proposal format. This conversion is best effort. New proposal types that
// don't have a legacy message will return a "nil" content

// type Item struct {
// 	Owner          string           `protobuf:"bytes,1,opt,name=owner,proto3" json:"owner,omitempty"`
// 	CookbookId     string           `protobuf:"bytes,2,opt,name=cookbook_id,json=cookbookId,proto3" json:"cookbook_id,omitempty"`
// 	Id             string           `protobuf:"bytes,3,opt,name=id,proto3" json:"id,omitempty"`
// 	NodeVersion    uint64           `protobuf:"varint,4,opt,name=node_version,json=nodeVersion,proto3" json:"node_version,omitempty"`
// 	Doubles        []DoubleKeyValue `protobuf:"bytes,5,rep,name=doubles,proto3" json:"doubles"`
// 	Longs          []LongKeyValue   `protobuf:"bytes,6,rep,name=longs,proto3" json:"longs"`
// 	Strings        []StringKeyValue `protobuf:"bytes,7,rep,name=strings,proto3" json:"strings"`
// 	MutableStrings []StringKeyValue `protobuf:"bytes,8,rep,name=mutable_strings,json=mutableStrings,proto3" json:"mutable_strings"`
// 	Tradeable      bool             `protobuf:"varint,9,opt,name=tradeable,proto3" json:"tradeable,omitempty"`
// 	LastUpdate     int64            `protobuf:"varint,10,opt,name=last_update,json=lastUpdate,proto3" json:"last_update,omitempty"`
// 	TransferFee    []types.Coin     `protobuf:"bytes,11,rep,name=transfer_fee,json=transferFee,proto3" json:"transfer_fee"`
// 	// The percentage of a trade sale retained by the cookbook owner. In the range (0.0, 1.0).
// 	TradePercentage github_com_cosmos_cosmos_sdk_types.Dec `protobuf:"bytes,12,opt,name=trade_percentage,json=tradePercentage,proto3,customtype=github.com/cosmos/cosmos-sdk/types.Dec" json:"trade_percentage"`
// 	CreatedAt       int64                                  `protobuf:"varint,13,opt,name=created_at,json=createdAt,proto3" json:"created_at,omitempty"`
// 	UpdatedAt       int64                                  `protobuf:"varint,14,opt,name=updated_at,json=updatedAt,proto3" json:"updated_at,omitempty"`
// 	RecipeId        string                                 `protobuf:"bytes,15,opt,name=recipe_id,json=recipeId,proto3" json:"recipe_id,omitempty"`
// }

func ConvertToNewItem(oldItem v1.Item) types.Item {
	return types.Item{
		Owner:           oldItem.Owner,
		CookbookId:      oldItem.CookbookID,
		Id:              oldItem.ID,
		NodeVersion:     oldItem.NodeVersion,
		Doubles:         oldItem.Doubles,
		Longs:           oldItem.Longs,
		Strings:         oldItem.Strings,
		MutableStrings:  oldItem.MutableStrings,
		Tradeable:       oldItem.Tradeable,
		LastUpdate:      oldItem.LastUpdate,
		TransferFee:     oldItem.TransferFee,
		TradePercentage: oldItem.TradePercentage,
		CreatedAt:       1659464074,
		UpdatedAt:       1659464074,
		RecipeId:        "0",
	}
}

// type Recipe struct {
// 	CookbookId    string            `protobuf:"bytes,1,opt,name=cookbook_id,json=cookbookId,proto3" json:"cookbook_id,omitempty"`
// 	Id            string            `protobuf:"bytes,2,opt,name=id,proto3" json:"id,omitempty"`
// 	NodeVersion   uint64            `protobuf:"varint,3,opt,name=node_version,json=nodeVersion,proto3" json:"node_version,omitempty"`
// 	Name          string            `protobuf:"bytes,4,opt,name=name,proto3" json:"name,omitempty"`
// 	Description   string            `protobuf:"bytes,5,opt,name=description,proto3" json:"description,omitempty"`
// 	Version       string            `protobuf:"bytes,6,opt,name=version,proto3" json:"version,omitempty"`
// 	CoinInputs    []CoinInput       `protobuf:"bytes,7,rep,name=coin_inputs,json=coinInputs,proto3" json:"coin_inputs"`
// 	ItemInputs    []ItemInput       `protobuf:"bytes,8,rep,name=item_inputs,json=itemInputs,proto3" json:"item_inputs"`
// 	Entries       EntriesList       `protobuf:"bytes,9,opt,name=entries,proto3" json:"entries"`
// 	Outputs       []WeightedOutputs `protobuf:"bytes,10,rep,name=outputs,proto3" json:"outputs"`
// 	BlockInterval int64             `protobuf:"varint,11,opt,name=block_interval,json=blockInterval,proto3" json:"block_interval,omitempty"`
// 	CostPerBlock  types.Coin        `protobuf:"bytes,12,opt,name=cost_per_block,json=costPerBlock,proto3" json:"cost_per_block"`
// 	Enabled       bool              `protobuf:"varint,13,opt,name=enabled,proto3" json:"enabled,omitempty"`
// 	ExtraInfo     string            `protobuf:"bytes,14,opt,name=extra_info,json=extraInfo,proto3" json:"extra_info,omitempty"`
// 	CreatedAt     int64             `protobuf:"varint,15,opt,name=created_at,json=createdAt,proto3" json:"created_at,omitempty"`
// 	UpdatedAt     int64             `protobuf:"varint,16,opt,name=updated_at,json=updatedAt,proto3" json:"updated_at,omitempty"`
// }

func ConvertToNewRecipe(oldRecipe v1.Recipe) types.Recipe {
	return types.Recipe{
		CookbookId:    oldRecipe.CookbookID,
		Id:            oldRecipe.ID,
		NodeVersion:   oldRecipe.NodeVersion,
		Name:          oldRecipe.Name,
		Description:   oldRecipe.Description,
		Version:       oldRecipe.Version,
		CoinInputs:    oldRecipe.CoinInputs,
		ItemInputs:    oldRecipe.ItemInputs,
		Entries:       oldRecipe.Entries,
		Outputs:       oldRecipe.Outputs,
		BlockInterval: oldRecipe.BlockInterval,
		CostPerBlock:  oldRecipe.CostPerBlock,
		Enabled:       oldRecipe.Enabled,
		ExtraInfo:     oldRecipe.ExtraInfo,
		CreatedAt:     1659464074,
		UpdatedAt:     1659464074,
	}
}

// func ConvertToNewParam(oldParams v1.Params) types.Params {

// }
