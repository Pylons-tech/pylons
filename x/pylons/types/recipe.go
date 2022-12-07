package types

import (
	"errors"

	"github.com/rogpeppe/go-internal/semver"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// RecipeModified checks if any field of recipe except creator (transfer of ownership is always allowed)
// is changed with respect to cookbookB. Valid edits require a higher version
func RecipeModified(original, updated Recipe) (bool, error) {
	modified := false
	if original.Name != updated.Name {
		modified = true
	}

	if original.Description != updated.Description {
		modified = true
	}

	if len(original.CoinInputs) != len(updated.CoinInputs) {
		modified = true
	} else {
		for i := range original.CoinInputs {
			if !original.CoinInputs[i].Coins.IsEqual(updated.CoinInputs[i].Coins) {
				modified = true
			}
		}
	}

	if original.BlockInterval != updated.BlockInterval {
		modified = true
	}

	if original.ExtraInfo != updated.ExtraInfo {
		modified = true
	}

	if original.Enabled != updated.Enabled {
		modified = true
	}

	if !ItemInputsEqual(original.ItemInputs, updated.ItemInputs) {
		modified = true
	}

	equal, err := EntriesListEqual(original.Entries, updated.Entries)
	if err != nil {
		return modified, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	if !equal {
		modified = true
	}

	if !OutputsEqual(original.Outputs, updated.Outputs) {
		modified = true
	}

	if original.CostPerBlock.Denom != updated.CostPerBlock.Denom {
		modified = true
	} else if original.CostPerBlock.IsEqual(updated.CostPerBlock) {
		modified = true
	}

	if modified {
		comp := semver.Compare(original.Version, updated.Version)
		if comp != -1 {
			return modified, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "version needs to be higher when updating")
		}
	}

	return modified, nil
}

func ItemInputsEqual(original, updated []ItemInput) bool {
	if len(original) == len(updated) {
		for i := range original {
			itemA := original[i]
			itemB := updated[i]

			if len(itemA.Longs) == len(itemB.Longs) {
				for j := range itemA.Longs {
					if itemA.Longs[j] != itemB.Longs[j] {
						return false
					}
				}
			} else {
				return false
			}

			if len(itemA.Strings) == len(itemB.Strings) {
				for j := range itemA.Strings {
					if itemA.Strings[j] != itemB.Strings[j] {
						return false
					}
				}
			} else {
				return false
			}

			if len(itemA.Doubles) == len(itemB.Doubles) {
				for j := range itemA.Doubles {
					if itemA.Doubles[j] != itemB.Doubles[j] {
						return false
					}
				}
			} else {
				return false
			}
		}
	} else {
		return false
	}

	return true
}

func EntriesListEqual(original, updated EntriesList) (bool, error) {
	if len(original.CoinOutputs) == len(updated.CoinOutputs) {
		for i := range original.CoinOutputs {
			coinA := original.CoinOutputs[i]
			coinB := updated.CoinOutputs[i]

			if coinA.Id != coinB.Id {
				return false, nil
			}

			if !coinA.Coin.Equal(coinB.Coin) {
				return false, nil
			}

			if coinA.Program != coinB.Program {
				return false, nil
			}
		}
	} else {
		return false, nil
	}

	if len(original.ItemOutputs) == len(updated.ItemOutputs) {
		for i := range original.ItemOutputs {
			originalItem := original.ItemOutputs[i]
			updatedItem := updated.ItemOutputs[i]

			if originalItem.Id != updatedItem.Id {
				return false, nil
			}

			// if AmountMinted is modified, return error as this is
			if originalItem.AmountMinted != updatedItem.AmountMinted {
				return false, errors.New("cannot modify AmountMinted field of a recipe")
			}

			if originalItem.Quantity != updatedItem.Quantity {
				// User may modify quantity unless updatedItem.Quantity < updatedItem.AmountMinted
				// return error if true
				if updatedItem.Quantity < updatedItem.AmountMinted {
					return false, errors.New("cannot set Quantity to be less than AmountMinted")
				}
				return false, nil
			}

			if originalItem.Tradeable != updatedItem.Tradeable {
				return false, nil
			}

			if len(originalItem.TransferFee) != len(updatedItem.TransferFee) {
				return false, nil
			}
			for i := range originalItem.TransferFee {
				if originalItem.TransferFee[i] != updatedItem.TransferFee[i] {
					return false, nil
				}
			}

			if len(originalItem.Doubles) == len(updatedItem.Doubles) {
				for j := range originalItem.Doubles {
					originalDouble := originalItem.Doubles[j]
					updatedDouble := updatedItem.Doubles[j]

					if originalDouble.Key != updatedDouble.Key {
						return false, nil
					}

					if originalDouble.Program != updatedDouble.Program {
						return false, nil
					}

					if len(originalDouble.WeightRanges) != len(updatedDouble.WeightRanges) {
						for k := range originalDouble.WeightRanges {
							originalWeight := originalDouble.WeightRanges[k]
							updatedWeight := updatedDouble.WeightRanges[k]
							if originalWeight.Weight != updatedWeight.Weight {
								return false, nil
							}
							if !originalWeight.Lower.Equal(updatedWeight.Lower) {
								return false, nil
							}
							if !originalWeight.Upper.Equal(updatedWeight.Upper) {
								return false, nil
							}
						}
					} else {
						return false, nil
					}
				}
			} else {
				return false, nil
			}

			if len(originalItem.Longs) == len(updatedItem.Longs) {
				for j := range originalItem.Longs {
					originalLong := originalItem.Longs[j]
					updatedLong := updatedItem.Longs[j]

					if originalLong.Key != updatedLong.Key {
						return false, nil
					}

					if originalLong.Program != updatedLong.Program {
						return false, nil
					}

					if len(originalLong.WeightRanges) != len(updatedLong.WeightRanges) {
						for k := range originalLong.WeightRanges {
							originalWeight := originalLong.WeightRanges[k]
							updatedWeight := updatedLong.WeightRanges[k]
							if originalWeight.Weight != updatedWeight.Weight {
								return false, nil
							}
							if originalWeight.Lower != updatedWeight.Lower {
								return false, nil
							}
							if originalWeight.Upper != updatedWeight.Upper {
								return false, nil
							}
						}
					} else {
						return false, nil
					}
				}
			} else {
				return false, nil
			}

			if len(originalItem.MutableStrings) == len(updatedItem.MutableStrings) {
				for j := range originalItem.MutableStrings {
					originalString := originalItem.MutableStrings[j]
					updatedString := updatedItem.MutableStrings[j]

					if originalString.Key != updatedString.Key {
						return false, nil
					}

					if originalString.Value != updatedString.Value {
						return false, nil
					}
				}
			} else {
				return false, nil
			}

			if len(originalItem.Strings) == len(updatedItem.Strings) {
				for j := range originalItem.Strings {
					originalString := originalItem.Strings[j]
					updatedString := updatedItem.Strings[j]

					if originalString.Key != updatedString.Key {
						return false, nil
					}

					if originalString.Program != updatedString.Program {
						return false, nil
					}

					if originalString.Value != updatedString.Value {
						return false, nil
					}
				}
			} else {
				return false, nil
			}
		}
	} else {
		return false, nil
	}

	if len(original.ItemModifyOutputs) == len(updated.ItemModifyOutputs) {
		for i := range original.ItemModifyOutputs {
			originalItem := original.ItemModifyOutputs[i]
			updatedItem := updated.ItemModifyOutputs[i]

			if originalItem.Id != updatedItem.Id {
				return false, nil
			}

			// if AmountMinted is modified, return error as this is
			if originalItem.AmountMinted != updatedItem.AmountMinted {
				return false, errors.New("cannot modify AmountMinted field of a recipe")
			}

			if originalItem.Quantity != updatedItem.Quantity {
				// User may modify quantity unless updatedItem.Quantity < updatedItem.AmountMinted
				// return error if true
				if updatedItem.Quantity < updatedItem.AmountMinted {
					return false, errors.New("cannot set Quantity to be less than AmountMinted")
				}
				return false, nil
			}

			if originalItem.Tradeable != updatedItem.Tradeable {
				return false, nil
			}

			if len(originalItem.TransferFee) != len(updatedItem.TransferFee) {
				return false, nil
			}
			for i := range originalItem.TransferFee {
				if originalItem.TransferFee[i] != updatedItem.TransferFee[i] {
					return false, nil
				}
			}

			if len(originalItem.Doubles) == len(updatedItem.Doubles) {
				for j := range originalItem.Doubles {
					originalDouble := originalItem.Doubles[j]
					updatedDouble := updatedItem.Doubles[j]

					if originalDouble.Key != updatedDouble.Key {
						return false, nil
					}

					if originalDouble.Program != updatedDouble.Program {
						return false, nil
					}

					if len(originalDouble.WeightRanges) != len(updatedDouble.WeightRanges) {
						for k := range originalDouble.WeightRanges {
							originalWeight := originalDouble.WeightRanges[k]
							updatedWeight := updatedDouble.WeightRanges[k]
							if originalWeight.Weight != updatedWeight.Weight {
								return false, nil
							}
							if !originalWeight.Lower.Equal(updatedWeight.Lower) {
								return false, nil
							}
							if !originalWeight.Upper.Equal(updatedWeight.Upper) {
								return false, nil
							}
						}
					} else {
						return false, nil
					}
				}
			} else {
				return false, nil
			}

			if len(originalItem.Longs) == len(updatedItem.Longs) {
				for j := range originalItem.Longs {
					originalLong := originalItem.Longs[j]
					updatedLong := updatedItem.Longs[j]

					if originalLong.Key != updatedLong.Key {
						return false, nil
					}

					if originalLong.Program != updatedLong.Program {
						return false, nil
					}

					if len(originalLong.WeightRanges) != len(updatedLong.WeightRanges) {
						for k := range originalLong.WeightRanges {
							originalWeight := originalLong.WeightRanges[k]
							updatedWeight := updatedLong.WeightRanges[k]
							if originalWeight.Weight != updatedWeight.Weight {
								return false, nil
							}
							if originalWeight.Lower != updatedWeight.Lower {
								return false, nil
							}
							if originalWeight.Upper != updatedWeight.Upper {
								return false, nil
							}
						}
					} else {
						return false, nil
					}
				}
			} else {
				return false, nil
			}

			if len(originalItem.Strings) == len(updatedItem.Strings) {
				for j := range originalItem.Strings {
					originalString := originalItem.Strings[j]
					updatedString := updatedItem.Strings[j]

					if originalString.Key != updatedString.Key {
						return false, nil
					}

					if originalString.Program != updatedString.Program {
						return false, nil
					}

					if originalString.Value != updatedString.Value {
						return false, nil
					}
				}
			} else {
				return false, nil
			}

			if len(originalItem.MutableStrings) == len(updatedItem.MutableStrings) {
				for j := range originalItem.MutableStrings {
					originalString := originalItem.MutableStrings[j]
					updatedString := updatedItem.MutableStrings[j]

					if originalString.Key != updatedString.Key {
						return false, nil
					}

					if originalString.Value != updatedString.Value {
						return false, nil
					}
				}
			} else {
				return false, nil
			}
		}
	} else {
		return false, nil
	}

	return true, nil
}

func OutputsEqual(original, updated []WeightedOutputs) bool {
	if len(original) == len(updated) {
		for i := range original {
			originalOutput := original[i]
			updatedOutput := updated[i]

			if originalOutput.Weight != updatedOutput.Weight {
				return false
			}

			if len(originalOutput.EntryIds) == len(updatedOutput.EntryIds) {
				for j := range originalOutput.EntryIds {
					originalID := originalOutput.EntryIds[j]
					updatedID := updatedOutput.EntryIds[j]
					if originalID != updatedID {
						return false
					}
				}
			} else {
				return false
			}
		}
	} else {
		return false
	}

	return true
}

func ValidateInputDoubles(dip []DoubleInputParam) error {
	doublesKeyMap := make(map[string]bool)
	for _, d := range dip {
		if d.MaxValue.LT(d.MinValue) {
			return sdkerrors.Wrapf(ErrInvalidRequestField, "maxValue cannot be less than minValue for double %s", d.Key)
		}
		if d.MinValue.IsNegative() {
			return sdkerrors.Wrapf(ErrInvalidRequestField, "minValue cannot be less than 0 for double %s", d.Key)
		}
		if _, ok := doublesKeyMap[d.Key]; ok {
			return sdkerrors.Wrapf(ErrInvalidRequestField, "key %s repeated in double itemInput list", d.Key)
		}
		doublesKeyMap[d.Key] = true
	}

	return nil
}

func ValidateInputLongs(lip []LongInputParam) error {
	longsKeyMap := make(map[string]bool)
	for _, l := range lip {
		if l.MaxValue < l.MinValue {
			return sdkerrors.Wrapf(ErrInvalidRequestField, "maxValue cannot be less than minValue for long %s", l.Key)
		}
		if l.MinValue < 0 {
			return sdkerrors.Wrapf(ErrInvalidRequestField, "minValue cannot be less than 0 for long %s", l.Key)
		}
		if _, ok := longsKeyMap[l.Key]; ok {
			return sdkerrors.Wrapf(ErrInvalidRequestField, "key %s repeated in long itemInput list", l.Key)
		}
		longsKeyMap[l.Key] = true
	}

	return nil
}

func ValidateInputStrings(sip []StringInputParam) error {
	stringsKeyMap := make(map[string]bool)
	for _, s := range sip {
		if _, ok := stringsKeyMap[s.Key]; ok {
			return sdkerrors.Wrapf(ErrInvalidRequestField, "key %s repeated in string itemInput list", s.Key)
		}
		stringsKeyMap[s.Key] = true
	}

	return nil
}

func ValidateItemInput(i ItemInput) error {
	err := ValidateID(i.Id)
	if i.Id != "" && err != nil {
		return err
	}

	err = ValidateInputDoubles(i.Doubles)
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

	return nil
}

func ValidateCoinOutput(co CoinOutput, idMap map[string]bool) error {
	err := ValidateID(co.Id)
	if err != nil {
		return err
	}

	if _, ok := idMap[co.Id]; ok {
		return sdkerrors.Wrapf(ErrInvalidRequestField, "id %s repeated in coinOutput list", co.Id)
	}
	idMap[co.Id] = true

	// Validate sdk coins
	if !co.Coin.IsValid() {
		return sdkerrors.Wrap(sdkerrors.ErrInvalidCoins, co.Coin.String())
	}

	// prevent ibc coins as coin outputs
	// theoretically, a cookbook could have the ID 'ibc'. This prevents coinOutputs from aliasing real ibc coins
	if IsIBCDenomRepresentation(co.Coin.Denom) {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidCoins, "coin denom %s is of ibc/{hash} - cannot be used as a coin output", co.Coin.Denom)
	}

	return nil
}

func ValidateDoubles(dp []DoubleParam, ce CelEnvCollection) error {
	keyMap := make(map[string]bool)
	for _, param := range dp {
		err := ValidateID(param.Key)
		if err != nil {
			return err
		}

		if _, ok := keyMap[param.Key]; ok {
			return sdkerrors.Wrapf(ErrInvalidRequestField, "key %s repeated in double param list", param.Key)
		}
		keyMap[param.Key] = true
		for _, item := range param.WeightRanges {
			if item.Upper.LT(item.Lower) {
				return sdkerrors.Wrapf(ErrInvalidRequestField, "upper value cannot be less than lower value for weigthRange of double param %s", param.Key)
			}
			if item.Lower.IsNegative() {
				return sdkerrors.Wrapf(ErrInvalidRequestField, "invalid negative lower value for weigthRange of double param %s", param.Key)
			}
		}

	}
	if len(dp) != 0 {
		if _, err := DoubleParamList(dp).Actualize(ce); err != nil {
			return sdkerrors.Wrapf(ErrInvalidRequestField, "double param list contains incompatible program %v", err)
		}
	}
	return nil
}

func ValidateLongs(lp []LongParam, ce CelEnvCollection) error {
	keyMap := make(map[string]bool)
	for _, param := range lp {
		err := ValidateID(param.Key)
		if err != nil {
			return err
		}

		if _, ok := keyMap[param.Key]; ok {
			return sdkerrors.Wrapf(ErrInvalidRequestField, "key %s repeated in long param list", param.Key)
		}
		keyMap[param.Key] = true

		for _, item := range param.WeightRanges {
			if item.Upper < item.Lower {
				return sdkerrors.Wrapf(ErrInvalidRequestField, "upper value cannot be less than lower value for weigthRange of long param %s", param.Key)
			}
			if item.Lower < 0 {
				return sdkerrors.Wrapf(ErrInvalidRequestField, "invalid negative lower value for weigthRange of long param %s", param.Key)
			}
		}
	}
	if len(lp) != 0 {
		if _, err := LongParamList(lp).Actualize(ce); err != nil {
			return sdkerrors.Wrapf(ErrInvalidRequestField, "long param list contains incompatible program %v", err)
		}
	}

	return nil
}

func ValidateStrings(sp []StringParam, ce CelEnvCollection) error {
	keyMap := make(map[string]bool)
	for _, param := range sp {
		err := ValidateID(param.Key)
		if err != nil {
			return err
		}

		if _, ok := keyMap[param.Key]; ok {
			return sdkerrors.Wrapf(ErrInvalidRequestField, "key %s repeated in string param list", param.Key)
		}
		keyMap[param.Key] = true
	}
	if len(sp) != 0 {
		if _, err := StringParamList(sp).Actualize(ce); err != nil {
			return sdkerrors.Wrapf(ErrInvalidRequestField, "string param list contains incompatible program %v", err)
		}
	}
	return nil
}

func ValidateMutableStrings(skv []StringKeyValue) error {
	keyMap := make(map[string]bool)
	for _, kv := range skv {
		err := ValidateID(kv.Key)
		if err != nil {
			return err
		}

		if _, ok := keyMap[kv.Key]; ok {
			return sdkerrors.Wrapf(ErrInvalidRequestField, "key %s repeated in string param list", kv.Key)
		}
		keyMap[kv.Key] = true
	}

	return nil
}

func ValidateItemOutputs(io []ItemOutput, idMap map[string]bool, ce CelEnvCollection) error {
	for _, item := range io {
		err := ValidateID(item.Id)
		if err != nil {
			return err
		}

		if _, ok := idMap[item.Id]; ok {
			return sdkerrors.Wrapf(ErrInvalidRequestField, "id %s repeated in itemOutput list", item.Id)
		}
		idMap[item.Id] = true

		err = ValidateDoubles(item.Doubles, ce)
		if err != nil {
			return err
		}

		err = ValidateLongs(item.Longs, ce)
		if err != nil {
			return err
		}

		err = ValidateStrings(item.Strings, ce)
		if err != nil {
			return err
		}

		err = ValidateMutableStrings(item.MutableStrings)
		if err != nil {
			return err
		}

		// item.TradePercentage must be in (0, 1)
		if !item.TradePercentage.IsNil() {
			if item.TradePercentage.LT(sdk.ZeroDec()) || item.TradePercentage.GTE(sdk.OneDec()) {
				return sdkerrors.Wrapf(ErrInvalidRequestField, "invalid trade percentage on itemOutput %s", item.Id)
			}
		}

		for _, tf := range item.TransferFee {
			if !tf.IsValid() {
				return sdkerrors.Wrapf(ErrInvalidRequestField, "invalid transferFee on ItemOutput %s", item.Id)
			}
		}
	}
	return nil
}

func ValidateItemModifyOutputs(imo []ItemModifyOutput, idMap map[string]bool, ce CelEnvCollection) error {
	for _, item := range imo {
		err := ValidateID(item.Id)
		if err != nil {
			return err
		}

		if _, ok := idMap[item.Id]; ok {
			return sdkerrors.Wrapf(ErrInvalidRequestField, "id %s repeated in itemModifyOutput list", item.Id)
		}
		idMap[item.Id] = true

		err = ValidateDoubles(item.Doubles, ce)
		if err != nil {
			return err
		}

		err = ValidateLongs(item.Longs, ce)
		if err != nil {
			return err
		}

		err = ValidateStrings(item.Strings, ce)
		if err != nil {
			return err
		}

		err = ValidateMutableStrings(item.MutableStrings)
		if err != nil {
			return err
		}

		// item.TradePercentage must be in (0, 1)
		if item.TradePercentage.LTE(sdk.ZeroDec()) || item.TradePercentage.GTE(sdk.OneDec()) {
			return sdkerrors.Wrapf(ErrInvalidRequestField, "invalid trade percentage on itemModifyOutput %s", item.Id)
		}

		for _, tf := range item.TransferFee {
			if !tf.IsValid() {
				return sdkerrors.Wrapf(ErrInvalidRequestField, "invalid transferFee on ItemOutput %s", item.Id)
			}
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
	ce := GetDefaultCelEnv()
	err := ValidateItemOutputs(el.ItemOutputs, idMap, ce)
	if err != nil {
		return err
	}

	err = ValidateItemModifyOutputs(el.ItemModifyOutputs, idMap, ce)
	if err != nil {
		return err
	}

	return nil
}

func ValidateOutputs(wo WeightedOutputs, idMap map[string]bool) error {
	for _, id := range wo.EntryIds {
		if _, ok := idMap[id]; !ok {
			return sdkerrors.Wrapf(ErrInvalidRequestField, "no valid entry found with ID %s", id)
		}
	}

	return nil
}
