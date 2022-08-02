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
func (io ItemOutput) Actualize(ctx sdk.Context, cookbookID string, recipeID string, addr sdk.AccAddress, ec CelEnvCollection, nodeVersion uint64) (Item, error) {
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
		CookbookId:      cookbookID,
		NodeVersion:     nodeVersion,
		Doubles:         dblActualize,
		Longs:           longActualize,
		Strings:         stringActualize,
		MutableStrings:  io.MutableStrings,
		Tradeable:       io.Tradeable,
		LastUpdate:      ctx.BlockHeight(),
		TransferFee:     io.TransferFee,
		TradePercentage: io.TradePercentage,
		RecipeId:        recipeID,
		CreatedAt:       ctx.BlockTime().Unix(),
		UpdatedAt:       ctx.BlockTime().Unix(),
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
	targetItem.UpdatedAt = ctx.BlockTime().Unix()
	return nil
}

// MatchItem checks if all the constraint match the given item
func (itemInput ItemInput) MatchItem(item Item, ec CelEnvCollection) error {
	if itemInput.Doubles != nil {
		for _, param := range itemInput.Doubles {
			double, ok := item.FindDouble(param.Key)
			if !ok {
				return sdkerrors.Wrapf(ErrItemMatch, "%s key is not available on the item: item_id=%s", param.Key, item.Id)
			}

			if !param.Has(double) {
				return sdkerrors.Wrapf(ErrItemMatch, "%s key range does not match: item_id=%s", param.Key, item.Id)
			}
		}
	}

	if itemInput.Longs != nil {
		for _, param := range itemInput.Longs {
			long, ok := item.FindLong(param.Key)
			if !ok {
				return sdkerrors.Wrapf(ErrItemMatch, "%s key is not available on the item: item_id=%s", param.Key, item.Id)
			}

			if !param.Has(long) {
				return sdkerrors.Wrapf(ErrItemMatch, "%s key range does not match: item_id=%s", param.Key, item.Id)
			}
		}
	}

	if itemInput.Strings != nil {
		for _, param := range itemInput.Strings {
			str, ok := item.FindString(param.Key)
			if !ok {
				return sdkerrors.Wrapf(ErrItemMatch, "%s key is not available on the item: item_id=%s", param.Key, item.Id)
			}
			if str != param.Value {
				return sdkerrors.Wrapf(ErrItemMatch, "%s key value does not match: item_id=%s", param.Key, item.Id)
			}
		}
	}
	return nil
}

// checkPaymentsPermutation is a helper function that checks if a permutation of transferFee indexes on items can be
// covered by balance
func checkPaymentsPermutation(items []Item, balance sdk.Coins, permutation []int) bool {
	// create sdk.Coins adding all selections of current permutation
	permTotalAmt := sdk.NewCoins()
	for i, transferFeeIdx := range permutation {
		// if transferFeeIdx >= len(items[i].TransferFee) this permutation is invalid
		if transferFeeIdx >= len(items[i].TransferFee) {
			return false
		}
		permTotalAmt = permTotalAmt.Add(items[i].TransferFee[transferFeeIdx])
	}

	return balance.IsAllGTE(permTotalAmt)
}

// newPaymentsPermutation increments by 1 permutation (as if it is a big-endian number in base val) starting from the
// lower index. Carry over the increment to the next position when value at current position exceeds val.
// A carry increases next element by val, instead of 1, when the carry happens at a position >= maxIndex.
// This is done to avoid checking the same permutation multiple times in FindValidPaymentsPermutation.
func newPaymentsPermutation(permutation []int, val, maxIndex int) ([]int, int) {
	for i := range permutation {
		permutation[i]++
		if permutation[i] <= val {
			// increment at this position was possible
			return permutation, i
		}
		// carry
		permutation[i] = 0
		if i > maxIndex && i < len(permutation)-1 {
			permutation[i+1] += val - 1
		}
	}
	// permutation is all 0s if we reach this point - an "overflow"
	return permutation, len(permutation)
}

// FindValidPaymentsPermutation searches through the transferFees of a slice []Item to find the first valid selection of
// transferFees that can be covered by the input balance of sdk.Coins. An item.transferFee is an ordered (by priority)
// []sdk.Coin that provides a set of choices to select from that are accepted as valid transferFee for the item.
// Returns a []int where each element at any given position represents the index used to select the relative
// transferFee for the item at the same position in the input []Item.
// When exploring the solution space the algorithm prioritizes the permutation where the max(permutation) is minimized.
// For example, for a set of 3 items the permutation [1,0,2] is preferred to [3,0,0] if both are valid.
func FindValidPaymentsPermutation(items []Item, balance sdk.Coins) ([]int, error) {
	if len(items) == 0 && balance.Empty() {
		ret := make([]int, 0)
		return ret, nil
	}

	if len(items) == 0 {
		return nil, errors.New("invalid set of Items provided")
	}

	if balance.Empty() || !balance.IsValid() {
		return nil, errors.New("invalid balance provided")
	}

	// represents the max(len(item.TransferFee)) for all items
	maxValue := 0

	// check if there is any item where none of the possible sdk.Coin in item.transferFee can be found in balance.
	// If this is the case, a valid permutation can never be found, hence return error.
	// The sdk.Coins.DenomsSubsetOf() function cannot be used here since elements of item.TransferFee get selected in a
	// mutually exclusive manner therefore need to be checked independently (a single match is sufficient)
	for _, item := range items {
		noMatchingDenoms := true
		if len(item.TransferFee) > maxValue {
			maxValue = len(item.TransferFee)
		}
		for _, coin := range item.TransferFee {
			if balance.AmountOf(coin.Denom).GTE(coin.Amount) {
				noMatchingDenoms = false
				break
			}
		}
		if noMatchingDenoms {
			return nil, fmt.Errorf("insufficient balance to transfer item with ID %v in cookbook with ID %v", item.Id, item.CookbookId)
		}
	}

	// initialize permutation to start from all 0-indexes on item.TransferFee (the lower the index the higher the priority)
	permutation := make([]int, len(items))
	// start by allowing 1 as max values to produce new permutations
	curMaxValue := 1
	// tracks the higher index when an increment of value has happened when producing a new permutation
	maxIndex := -1
	// loop until curMaxValue can be incremented and new permutations can be produced
	for curMaxValue <= maxValue {
		// check if current permutation is valid
		// ok to check invalid permutations (where a value at position I would be greater than len(items[I].TransferFee))
		// invalid permutations are going to be produced as a result of how the algorithm works - we include and check
		// invalid permutations to keep the algorithm simple
		if checkPaymentsPermutation(items, balance, permutation) {
			return permutation, nil
		}
		// create a new permutation but clamp values to curMaxValue
		// by setting curMaxValue as max value to assign in newPaymentsPermutation(), we direct the search
		// of the solution space to prioritize permutations where max(permutation) is minimized
		permutation, maxIndex = newPaymentsPermutation(permutation, curMaxValue, maxIndex)
		if maxIndex >= len(items) {
			maxIndex = -1
			curMaxValue++
			// find the first item for which new curMaxValue would be valid and create new permutation with all 0s except
			// the value at that position
			for i := range permutation {
				if len(items[i].TransferFee) >= curMaxValue {
					permutation[i] = curMaxValue
					break
				}
			}
		}
	}
	return nil, errors.New("no valid set of items' transferFees exists that can be covered by the provided balance")
}

func (it Item) NewItemHistory(ctx sdk.Context, to, from string) ItemHistory {
	return ItemHistory{
		CookbookId: it.CookbookId,
		Id:         it.Id,
		To:         to,
		From:       from,
		CreatedAt:  ctx.BlockTime().Unix(),
	}
}
