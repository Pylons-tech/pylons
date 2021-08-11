package types

import (
	"encoding/binary"
	"github.com/btcsuite/btcutil/base58"
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/config"
)

// EncodeItemID encodes the internal uint64 representation of an ItemID to a base64 string
func EncodeItemID(id uint64) string {
	b := make([]byte, 8)
	binary.LittleEndian.PutUint64(b, id)
	return base58.Encode(b)
}

// DecodeItemID decodes base64 string representation of an ItemID to the internal uint64 representation
func DecodeItemID(id string) uint64 {
	bytes := base58.Decode(id)
	return binary.LittleEndian.Uint64(bytes)
}

// FindDouble is a function to get a double attribute from an item
func (it Item) FindDouble(key string) (sdk.Dec, bool) {
	for _, v := range it.Doubles {
		if v.Key == key {
			return v.Value, true
		}
	}
	return sdk.NewDec(0), false
}

// FindDoubleKey is a function get double key index
func (it Item) FindDoubleKey(key string) (int, bool) {
	for i, v := range it.Doubles {
		if v.Key == key {
			return i, true
		}
	}
	return 0, false
}

// FindLong is a function to get a long attribute from an item
func (it Item) FindLong(key string) (int, bool) {
	for _, v := range it.Longs {
		if v.Key == key {
			return int(v.Value), true
		}
	}
	return 0, false
}

// FindLongKey is a function to get long key index
func (it Item) FindLongKey(key string) (int, bool) {
	for i, v := range it.Longs {
		if v.Key == key {
			return i, true
		}
	}
	return 0, false
}

// FindString is a function to get a string attribute from an item
func (it Item) FindString(key string) (string, bool) {
	for _, v := range it.Strings {
		if v.Key == key {
			return v.Value, true
		}
	}
	return "", false
}

// FindStringKey is a function to get string key index
func (it Item) FindStringKey(key string) (int, bool) {
	for i, v := range it.Strings {
		if v.Key == key {
			return i, true
		}
	}
	return 0, false
}

// Actualize function actualize an item from item output data
func (io ItemOutput) Actualize(ctx sdk.Context, cookbookID string, recipeID string, addr sdk.AccAddress, ec CelEnvCollection) (Item, error) {
	dblActualize, err := DoubleParamList(io.Doubles).Actualize(ec)
	if err != nil {
		return Item{}, err
	}
	longActualize, err := LongParamList(io.Longs).Actualize(ec)
	if err != nil {
		return Item{}, err
	}
	stringActualize, err := StringParamList(io.Strings).Actualize(ec)
	if err != nil {
		return Item{}, err
	}

	// transferFee := io.TransferFee

	// TODO
	// Can't we just remove the ec "lastBlockHeight" var entirely?
	// lastBlockHeight := ec.variables["lastBlockHeight"].(int64)

	// GetItemCount from keeper
	// item ID = EncodeItemID(itemCount + 1)
	// SetItemCount to (itemCount + 1) in keeper

	return Item{
		Owner:          addr.String(),
		CookbookID:     cookbookID,
		RecipeID:       recipeID,
		ID:             "", // TODO SET
		NodeVersion:    config.GetNodeVersionString(),
		Doubles:        dblActualize,
		Longs:          longActualize,
		Strings:        stringActualize,
		MutableStrings: nil,  // TODO HOW DO WE SET THIS?
		Tradeable:      true, // TODO HOW DO WE SET THIS?
		LastUpdate:     uint64(ctx.BlockHeight()),
		TransferFee:    0, // TODO ItemOutput Transfer fee is an sdk.Dec and this is a uint
	}, nil
}
