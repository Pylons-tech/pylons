package types

import (
	"encoding/base64"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"strconv"
)

// EncodeItemID
func EncodeItemID(id uint64) string {
	return base64.StdEncoding.EncodeToString([]byte(strconv.ParseUint(id, 10)))
}

// DecodeItemID()
// func DecodeItemID(id string) uint64 {
//	bytes := base64.StdEncoding.Decode([]byte(strconv.ParseUint(id, 10)))
// }


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
func (io ItemOutput) Actualize(cookbookID string, recipeID string, addr sdk.AccAddress, ec CelEnvCollection) (Item, error) {
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

	transferFee := io.TransferFee

	lastBlockHeight := ec.variables["lastBlockHeight"].(int64)

	return Item{
		Owner:          addr.String(),
		CookbookID:     ,
		RecipeID:       "",
		ID:             "",
		NodeVersion:    "",
		Doubles:        nil,
		Longs:          nil,
		Strings:        nil,
		MutableStrings: nil,
		Tradeable:      false,
		LastUpdate:     0,
		TransferFee:    0,
	}, nil
}
