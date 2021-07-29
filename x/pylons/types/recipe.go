package types

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func ValidateInputDoubles(dip []DoubleInputParam) error {
	doublesKeyMap := make(map[string]bool)
	for _, d := range dip {
		if d.MaxValue.LT(d.MinValue) {
			return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("minValue cannot be less than maxValue for double %s", d.Key))
		}
		if d.MinValue.IsNegative() {
			return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("minValue cannot be less than 0 for double %s", d.Key))
		}
		if _, ok := doublesKeyMap[d.Key]; ok {
			return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("key %s repeated in double itemInput list", d.Key))
		}
		doublesKeyMap[d.Key] = true
	}

	return nil
}

func ValidateInputLongs(lip []LongInputParam) error {
	longsKeyMap := make(map[string]bool)
	for _, l := range lip {
		if l.MaxValue < l.MinValue {
			return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("minValue cannot be less than maxValue for long %s", l.Key))
		}
		if l.MinValue < 0 {
			return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("minValue cannot be less than 0 for long %s", l.Key))
		}
		if _, ok := longsKeyMap[l.Key]; ok {
			return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("key %s repeated in long itemInput list", l.Key))
		}
		longsKeyMap[l.Key] = true
	}

	return nil
}

func ValidateInputStrings(sip []StringInputParam) error {
	stringsKeyMap := make(map[string]bool)
	for _, s := range sip {
		if _, ok := stringsKeyMap[s.Key]; ok {
			return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("key %s repeated in string itemInput list", s.Key))
		}
		stringsKeyMap[s.Key] = true
	}

	return nil
}

func ValidateItemInput(i ItemInput) error {
	err := ValidateInputDoubles(i.Doubles)
	if err != nil {
		return err
	}

	err = ValidateInputLongs(i.Longs)
	if err != nil {
		return err
	}

	err = ValidateInputStrings(i.Strings)
	if err != nil {
		return err
	}

	err = ValidateInputDoubles(i.Conditions.Doubles)
	if err != nil {
		return err
	}

	err = ValidateInputLongs(i.Conditions.Longs)
	if err != nil {
		return err
	}

	err = ValidateInputStrings(i.Conditions.Strings)
	if err != nil {
		return err
	}

	return nil
}

func ValidateCoinOutput(co CoinOutput, idMap map[string]bool) error {
	err := ValidateID(co.ID)
	if err != nil {
		return err
	}

	if _, ok := idMap[co.ID]; ok {
		return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("id %s repeated in coinOutput list", co.ID))
	}
	idMap[co.ID] = true

	// Validate sdk coins
	if !co.Coins.IsValid() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidCoins, co.Coins.String())
	}

	if !co.Coins.IsAllPositive() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidCoins, co.Coins.String())
	}

	return nil
}

func ValidateDoubles(dp []DoubleParam) error {
	keyMap := make(map[string]bool)
	for _, param := range dp {
		err := ValidateID(param.Key)
		if err != nil {
			return err
		}

		if _, ok := keyMap[param.Key]; ok {
			return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("key %s repeated in double param list", param.Key))
		}
		keyMap[param.Key] = true

		// rate must be in (0, 1]
		if param.Rate.LTE(sdk.NewDec(0)) || param.Rate.GT(sdk.NewDec(1)) {
			return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("invalid rate on double param %s", param.Key))
		}

		for _, item := range param.WeightRanges {
			if item.Upper.LT(item.Lower) {
				return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("upper value cannot be less than lower value for weigthRange of double param %s", param.Key))
			}
			if item.Lower.IsNegative() {
				return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("invalid negative lower value for weigthRange of double param %s", param.Key))
			}
		}

	}

	return nil
}

func ValidateLongs(lp []LongParam) error {
	keyMap := make(map[string]bool)
	for _, param := range lp {
		err := ValidateID(param.Key)
		if err != nil {
			return err
		}

		if _, ok := keyMap[param.Key]; ok {
			return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("key %s repeated in long param list", param.Key))
		}
		keyMap[param.Key] = true

		// rate must be in (0, 1]
		if param.Rate.LTE(sdk.NewDec(0)) || param.Rate.GT(sdk.NewDec(1)) {
			return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("invalid rate on long param %s", param.Key))
		}

		for _, item := range param.WeightRanges {
			if item.Upper < item.Lower {
				return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("upper value cannot be less than lower value for weigthRange of long param %s", param.Key))
			}
			if item.Lower < 0 {
				return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("invalid negative lower value for weigthRange of long param %s", param.Key))
			}
		}
	}

	return nil
}

func ValidateStrings(sp []StringParam) error {
	keyMap := make(map[string]bool)
	for _, param := range sp {
		err := ValidateID(param.Key)
		if err != nil {
			return err
		}

		if _, ok := keyMap[param.Key]; ok {
			return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("key %s repeated in string param list", param.Key))
		}
		keyMap[param.Key] = true

		// rate must be in (0, 1]
		if param.Rate.LTE(sdk.NewDec(0)) || param.Rate.GT(sdk.NewDec(1)) {
			return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("invalid rate on string param %s", param.Key))
		}
	}

	return nil
}

func ValidateItemOutputs(io []ItemOutput, idMap map[string]bool) error {
	for _, item := range io {
		err := ValidateID(item.ID)
		if err != nil {
			return err
		}

		if _, ok := idMap[item.ID]; ok {
			return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("id %s repeated in itemOutput list", item.ID))
		}
		idMap[item.ID] = true

		err = ValidateDoubles(item.Doubles)
		if err != nil {
			return err
		}

		err = ValidateLongs(item.Longs)
		if err != nil {
			return err
		}

		err = ValidateStrings(item.Strings)
		if err != nil {
			return err
		}

		err = ValidateStrings(item.MutableStrings)
		if err != nil {
			return err
		}

		if item.TransferFee.IsNegative() || item.TransferFee.GTE(sdk.NewDec(1)) {
			return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("invalid transferFee on ItemOutput %s", item.ID))
		}

	}
	return nil
}

func ValidateItemModifyOutputs(imo []ItemModifyOutput, idMap map[string]bool) error {
	for _, item := range imo {
		err := ValidateID(item.ID)
		if err != nil {
			return err
		}

		if _, ok := idMap[item.ID]; ok {
			return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("id %s repeated in itemOutput list", item.ID))
		}
		idMap[item.ID] = true

		err = ValidateDoubles(item.Doubles)
		if err != nil {
			return err
		}

		err = ValidateLongs(item.Longs)
		if err != nil {
			return err
		}

		err = ValidateStrings(item.Strings)
		if err != nil {
			return err
		}

		if item.TransferFee.IsNegative() || item.TransferFee.GTE(sdk.NewDec(1)) {
			return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("invalid transferFee on ItemOutput %s", item.ID))
		}
	}

	return nil
}

func ValidateEntriesList(el EntriesList, idMap map[string]bool) error {
	for _, co := range el.CoinOutputs {
		err := ValidateCoinOutput(co, idMap)
		if err != nil {
			return err
		}
	}

	err := ValidateItemOutputs(el.ItemOutputs, idMap)
	if err != nil {
		return err
	}

	err = ValidateItemModifyOutputs(el.ItemModifyOutputs, idMap)
	if err != nil {
		return err
	}

	return nil
}

func ValidateOutputs(wo WeightedOutputs, idMap map[string]bool) error {
	for _, id := range wo.EntryIDs {
		if _, ok := idMap[id]; !ok {
			return sdkerrors.Wrap(ErrInvalidRequestField, fmt.Sprintf("no valid entry found with ID %s", id))
		}
	}

	return nil
}
