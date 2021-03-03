package types

import (
	"errors"
	"fmt"
	"regexp"
)

func ItemInputsToProto(items []Item) []*Item {
	var res []*Item
	for _, item := range items {
		res = append(res, &item)
	}
	return res
}

// MatchError checks if all the constraint match the given item
func (ii ItemInput) MatchError(item Item) error {

	if ii.Doubles != nil {
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

	if ii.Longs != nil {
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

	if ii.Strings != nil {
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

	if ii.TransferFee != nil {
		if !ii.TransferFee.Has(item.TransferFee) {
			return fmt.Errorf("item transfer fee does not match: fee=%d range=%s", item.TransferFee, ii.TransferFee.String())
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

// Validate is a function to check ItemInputList is valid
func (iil ItemInputList) Validate() error {
	return nil
}

// MatchError checks if all the constraint match the given item
func (tii TradeItemInput) MatchError(item Item) error {
	if item.CookbookID != tii.CookbookID {
		return fmt.Errorf("cookbook id does not match")
	}
	return tii.ItemInput.MatchError(item)
}

// Validate is a function to check ItemInputList is valid
func (tiil TradeItemInputList) Validate() error {
	for _, ii := range tiil.List {
		if ii.CookbookID == "" {
			return errors.New("There should be no empty cookbook ID inputs for trades")
		}
	}
	return nil
}
