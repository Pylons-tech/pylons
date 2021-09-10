package types

import (
	"encoding/binary"
	"errors"
	"fmt"

	"github.com/btcsuite/btcutil/base58"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
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
	return sdk.ZeroDec(), false
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
func (io ItemOutput) Actualize(ctx sdk.Context, cookbookID string, addr sdk.AccAddress, ec CelEnvCollection) (Item, error) {
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

	return Item{
		// ID not set - it's handled internally
		Owner:           addr.String(),
		CookbookID:      cookbookID,
		NodeVersion:     GetNodeVersionString(),
		Doubles:         dblActualize,
		Longs:           longActualize,
		Strings:         stringActualize,
		MutableStrings:  io.MutableStrings,
		Tradeable:       io.Tradeable,
		LastUpdate:      ctx.BlockHeight(),
		TransferFee:     io.TransferFee,
		TradePercentage: io.TradePercentage,
	}, nil
}

// Actualize is used to update an existing item from an ItemModifyOutout
func (io ItemModifyOutput) Actualize(targetItem *Item, ctx sdk.Context, addr sdk.AccAddress, ec CelEnvCollection) error {
	if io.Doubles != nil {
		dblKeyValues, err := DoubleParamList(io.Doubles).Actualize(ec)
		if err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrLogic, err.Error())
		}
		for idx, dbl := range dblKeyValues {
			dblKey, ok := targetItem.FindDoubleKey(dbl.Key)
			if !ok {
				return sdkerrors.Wrapf(sdkerrors.ErrKeyNotFound, "could not find double %s on item to be updated", dbl.Key)
			}
			if len(io.Doubles[idx].Program) == 0 { // NO PROGRAM
				originValue := targetItem.Doubles[dblKey].Value
				upgradeAmount := dbl.Value
				targetItem.Doubles[dblKey].Value = originValue.Add(upgradeAmount)
			} else {
				targetItem.Doubles[dblKey].Value = dbl.Value
			}
		}
	}

	if io.Longs != nil {
		lngKeyValues, err := LongParamList(io.Longs).Actualize(ec)
		if err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrLogic, err.Error())
		}
		for idx, lng := range lngKeyValues {
			lngKey, ok := targetItem.FindLongKey(lng.Key)
			if !ok {
				return sdkerrors.Wrapf(sdkerrors.ErrKeyNotFound, "could not find long %s on item to be updated", lng.Key)
			}
			if len(io.Longs[idx].Program) == 0 { // NO PROGRAM
				targetItem.Longs[lngKey].Value += lng.Value
			} else {
				targetItem.Longs[lngKey].Value = lng.Value
			}
		}
	}

	if io.Strings != nil {
		strKeyValues, err := StringParamList(io.Strings).Actualize(ec)
		if err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrLogic, err.Error())
		}
		for _, str := range strKeyValues {
			strKey, ok := targetItem.FindStringKey(str.Key)
			if !ok {
				return sdkerrors.Wrapf(sdkerrors.ErrKeyNotFound, "could not find string %s on item to be updated", str.Key)
			}
			targetItem.Strings[strKey].Value = str.Value
		}
	}

	// only add non-existing key-value pairs
	if io.MutableStrings != nil {
	OuterLoop:
		for _, newStr := range io.MutableStrings {
			for _, str := range targetItem.MutableStrings {
				if str.Key == newStr.Key {
					continue OuterLoop
				}
			}
			// entry not found
			targetItem.MutableStrings = append(targetItem.MutableStrings, newStr)
		}
	}

	targetItem.LastUpdate = ctx.BlockHeight()
	targetItem.Owner = addr.String()
	targetItem.TransferFee = io.TransferFee
	targetItem.TradePercentage = io.TradePercentage
	return nil
}

// MatchItem checks if all the constraint match the given item
func (itemInput ItemInput) MatchItem(item Item, ec CelEnvCollection) error {
	if itemInput.Doubles != nil {
		for _, param := range itemInput.Doubles {
			double, ok := item.FindDouble(param.Key)
			if !ok {
				return sdkerrors.Wrapf(ErrItemMatch, "%s key is not available on the item: item_id=%s", param.Key, item.ID)
			}

			if !param.Has(double) {
				return sdkerrors.Wrapf(ErrItemMatch, "%s key range does not match: item_id=%s", param.Key, item.ID)
			}
		}
	}

	if itemInput.Longs != nil {
		for _, param := range itemInput.Longs {
			long, ok := item.FindLong(param.Key)
			if !ok {
				return sdkerrors.Wrapf(ErrItemMatch, "%s key is not available on the item: item_id=%s", param.Key, item.ID)
			}

			if !param.Has(long) {
				return sdkerrors.Wrapf(ErrItemMatch, "%s key range does not match: item_id=%s", param.Key, item.ID)
			}
		}
	}

	if itemInput.Strings != nil {
		for _, param := range itemInput.Strings {
			str, ok := item.FindString(param.Key)
			if !ok {
				return sdkerrors.Wrapf(ErrItemMatch, "%s key is not available on the item: item_id=%s", param.Key, item.ID)
			}
			if str != param.Value {
				return sdkerrors.Wrapf(ErrItemMatch, "%s key value does not match: item_id=%s", param.Key, item.ID)
			}
		}
	}

	for _, param := range itemInput.Conditions.Doubles {
		double, err := ec.EvalFloat64(param.Key)
		if err != nil {
			return sdkerrors.Wrapf(ErrItemMatch, "%s expression is invalid: item_id=%s, %+v", param.Key, item.ID, err.Error())
		}

		dec, err := sdk.NewDecFromStr(fmt.Sprintf("%v", double))
		if err != nil {
			return err
		}

		if !param.Has(dec) {
			return sdkerrors.Wrapf(ErrItemMatch, "%s expression range does not match: item_id=%s", param.Key, item.ID)
		}
	}

	for _, param := range itemInput.Conditions.Longs {
		long, err := ec.EvalInt64(param.Key)
		if err != nil {
			return sdkerrors.Wrapf(ErrItemMatch, "%s expression is invalid: item_id=%s, %+v", param.Key, item.ID, err.Error())
		}

		if !param.Has(int(long)) {
			return sdkerrors.Wrapf(ErrItemMatch, "%s expression range does not match: item_id=%s", param.Key, item.ID)
		}
	}

	for _, param := range itemInput.Conditions.Strings {
		str, err := ec.EvalString(param.Key)
		if err != nil {
			return sdkerrors.Wrapf(ErrItemMatch, "%s expression is invalid: item_id=%s, %+v", param.Key, item.ID, err.Error())
		}
		if str != param.Value {
			return sdkerrors.Wrapf(ErrItemMatch, "%s expression value does not match: item_id=%s", param.Key, item.ID)
		}
	}
	return nil
}

// FindValidPaymentsPermutation searches through the transferFees of a []Item to find a permutation
// of payments from a balance of sdk.Coins.  The permutation is a valid set of sdk.Coins from
// balance that can cover all transferFees in the set of []Item simultaneously.
func FindValidPaymentsPermutation(items []Item, balance sdk.Coins) ([]int, error) {
	if balance.IsZero() {
		return nil, errors.New("balance not sufficient")
	}

	// check if there is any item in the set of Items where the set of coin denoms of its transferFee
	// is disjoint with the set of denoms in balance.  If this is the case, a valid permutation can
	// never be found -> return error.
	for _, item := range items {
		noMatchingDenoms := true
		for _, coin := range item.TransferFee {
			amt := balance.AmountOf(coin.Denom)
			if !amt.IsZero() {
				noMatchingDenoms = false
			}
		}
		if noMatchingDenoms {
			return nil, errors.New("balance specified in coin inputs invalid")
		}
	}

	// initialize permutation to start from all 0s
	permutation := make([]int, len(items))
	// the current index
	index := 0
	// the last index in permutation that has maxed out
	maxedOutIndex := -1
	for {
		// create transferFees using the current permutation
		totalAmt := sdk.NewCoins()
		for i, transferFeeIdx := range permutation {
			totalAmt = totalAmt.Add(items[i].TransferFee[transferFeeIdx])
		}
		if balance.IsAllGTE(totalAmt) {
			// found a valid items transferFee permutation
			return permutation, nil
		}

		// create new permutation
		incrTransferFeeIdx := permutation[index] + 1
		if incrTransferFeeIdx > len(items[index].TransferFee) {
			permutation[index] = 0
		} else {
			permutation[index] = incrTransferFeeIdx
		}
		incrMaxedOutIndex := maxedOutIndex + 1
		if permutation[index] == len(items[index].TransferFee) && index <= incrMaxedOutIndex {
			maxedOutIndex = incrMaxedOutIndex
			for i := maxedOutIndex + 1; i < len(permutation); i++ {
				// reset all successive items' transferFeeIdx
				permutation[index] = 0
			}
		}

		if maxedOutIndex >= len(permutation) {
			// all items' transferFeeIdx maxed out, no new permutations available to test
			return nil, errors.New("balance not sufficient")
		}
		incrIndex := index + 1
		if incrIndex > len(items) {
			index = 0
		} else {
			index = incrIndex
		}
	}
}
