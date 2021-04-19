package types

import (
	"errors"
	"fmt"
	"regexp"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// MatchError checks if all the constraint match the given item
func (ii ItemInput) MatchError(item Item, ec CelEnvCollection) error {

	if ii.Doubles.Params != nil {
		for _, param := range ii.Doubles.Params {
			double, ok := item.FindDouble(param.Key)
			if !ok {
				return fmt.Errorf("%s key is not available on the item: item_id=%s", param.Key, item.ID)
			}

			if !param.Has(double) {
				return fmt.Errorf("%s key range does not match: item_id=%s", param.Key, item.ID)
			}
		}
	}

	if ii.Longs.List != nil {
		for _, param := range ii.Longs.List {
			long, ok := item.FindLong(param.Key)
			if !ok {
				return fmt.Errorf("%s key is not available on the item: item_id=%s", param.Key, item.ID)
			}

			if !param.Has(long) {
				return fmt.Errorf("%s key range does not match: item_id=%s", param.Key, item.ID)
			}
		}
	}

	if ii.Strings.List != nil {
		for _, param := range ii.Strings.List {
			str, ok := item.FindString(param.Key)
			if !ok {
				return fmt.Errorf("%s key is not available on the item: item_id=%s", param.Key, item.ID)
			}
			if str != param.Value {
				return fmt.Errorf("%s key value does not match: item_id=%s", param.Key, item.ID)
			}
		}
	}

	if !ii.TransferFee.Has(item.TransferFee) {
		return fmt.Errorf("item transfer fee does not match: fee=%d range=%s", item.TransferFee, ii.TransferFee.String())
	}

	for _, param := range ii.Conditions.Doubles.Params {
		double, err := ec.EvalFloat64(param.Key)
		if err != nil {
			return fmt.Errorf("%s expression is invalid: item_id=%s, %+v", param.Key, item.ID, err)
		}

		dec, err := sdk.NewDecFromStr(fmt.Sprintf("%v", double))
		if err != nil {
			return err
		}

		if !param.Has(dec) {
			return fmt.Errorf("%s expression range does not match: item_id=%s", param.Key, item.ID)
		}
	}

	for _, param := range ii.Conditions.Longs.List {
		long, err := ec.EvalInt64(param.Key)
		if err != nil {
			return fmt.Errorf("%s expression is invalid: item_id=%s, %+v", param.Key, item.ID, err)
		}

		if !param.Has(int(long)) {
			return fmt.Errorf("%s expression range does not match: item_id=%s", param.Key, item.ID)
		}
	}

	for _, param := range ii.Conditions.Strings.List {
		str, err := ec.EvalString(param.Key)
		if err != nil {
			return fmt.Errorf("%s expression is invalid: item_id=%s, %+v", param.Key, item.ID, err)
		}
		if str != param.Value {
			return fmt.Errorf("%s expression value does not match: item_id=%s", param.Key, item.ID)
		}
	}
	return nil
}

// IDValidationError check if ID can be used as a variable name if available
func (ii ItemInput) IDValidationError() error {
	if len(ii.ID) == 0 {
		return nil
	}

	regex := regexp.MustCompile(`^[a-zA-Z_][a-zA-Z_0-9]*$`)
	if regex.MatchString(ii.ID) {
		return nil
	}

	return fmt.Errorf("ID is not empty nor fit the regular expression ^[a-zA-Z_][a-zA-Z_0-9]*$: id=%s", ii.ID)
}

type ItemInputList []ItemInput

// Validate is a function to check ItemInputList is valid
func (iil ItemInputList) Validate() error {
	return nil
}

// MatchError checks if all the constraint match the given item
func (tii TradeItemInput) MatchError(item Item, ec CelEnvCollection) error {
	if item.CookbookID != tii.CookbookID {
		return fmt.Errorf("cookbook id does not match")
	}
	return tii.ItemInput.MatchError(item, ec)
}

type TradeItemInputList []TradeItemInput

// Validate is a function to check ItemInputList is valid
func (tiil TradeItemInputList) Validate() error {
	for _, ii := range tiil {
		if ii.CookbookID == "" {
			return errors.New("There should be no empty cookbook ID inputs for trades")
		}
	}
	return nil
}
