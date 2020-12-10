package types

import (
	"errors"
	"fmt"
	"regexp"
)

// ConditionList is a struct for describing  ItemInput expression conditions
type ConditionList struct {
	Doubles DoubleInputParamList
	Longs   LongInputParamList
	Strings StringInputParamList
}

// ItemInput is a wrapper struct for Item for recipes
type ItemInput struct {
	ID          string
	Doubles     DoubleInputParamList
	Longs       LongInputParamList
	Strings     StringInputParamList
	TransferFee FeeInputParam
	Conditions  ConditionList
}

// MatchError checks if all the constraint match the given item
func (ii ItemInput) MatchError(item Item, ec CelEnvCollection) error {

	for _, param := range ii.Doubles {
		double, ok := item.FindDouble(param.Key)
		if !ok {
			return fmt.Errorf("%s key is not available on the item: item_id=%s", param.Key, item.ID)
		}

		if !param.Has(double) {
			return fmt.Errorf("%s key range does not match: item_id=%s", param.Key, item.ID)
		}
	}

	for _, param := range ii.Longs {
		long, ok := item.FindLong(param.Key)
		if !ok {
			return fmt.Errorf("%s key is not available on the item: item_id=%s", param.Key, item.ID)
		}

		if !param.Has(long) {
			return fmt.Errorf("%s key range does not match: item_id=%s", param.Key, item.ID)
		}
	}

	for _, param := range ii.Strings {
		str, ok := item.FindString(param.Key)
		if !ok {
			return fmt.Errorf("%s key is not available on the item: item_id=%s", param.Key, item.ID)
		}
		if str != param.Value {
			return fmt.Errorf("%s key value does not match: item_id=%s", param.Key, item.ID)
		}
	}

	if !ii.TransferFee.Has(item.TransferFee) {
		return fmt.Errorf("item transfer fee does not match: fee=%d range=%s", item.TransferFee, ii.TransferFee.String())
	}

	for _, param := range ii.Conditions.Doubles {
		double, err := ec.EvalFloat64(param.Key)
		if err != nil {
			return fmt.Errorf("%s expression is not available on the item: item_id=%s", param.Key, item.ID)
		}

		if !param.Has(double) {
			return fmt.Errorf("%s expression range does not match: item_id=%s", param.Key, item.ID)
		}
	}

	for _, param := range ii.Conditions.Longs {
		long, err := ec.EvalInt64(param.Key)
		if err != nil {
			return fmt.Errorf("%s expression is not available on the item: item_id=%s", param.Key, item.ID)
		}

		if !param.Has(int(long)) {
			return fmt.Errorf("%s expression range does not match: item_id=%s", param.Key, item.ID)
		}
	}

	for _, param := range ii.Conditions.Strings {
		str, err := ec.EvalString(param.Key)
		if err != nil {
			return fmt.Errorf("%s expression is not available on the item: item_id=%s", param.Key, item.ID)
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

// ItemInputList is a list of ItemInputs for convinience
type ItemInputList []ItemInput

func (iil ItemInputList) String() string {
	itm := "ItemInputList{"

	for _, input := range iil {
		itm += fmt.Sprintf("%+v", input) + ",\n"
	}

	itm += "}"
	return itm
}

// Validate is a function to check ItemInputList is valid
func (iil ItemInputList) Validate() error {
	return nil
}

// TradeItemInput is a wrapper struct for Item for trades
type TradeItemInput struct {
	ItemInput  ItemInput
	CookbookID string
}

// MatchError checks if all the constraint match the given item
func (tii TradeItemInput) MatchError(item Item, ec CelEnvCollection) error {
	if item.CookbookID != tii.CookbookID {
		return fmt.Errorf("cookbook id does not match")
	}
	return tii.ItemInput.MatchError(item, ec)
}

// TradeItemInputList is a list of ItemInputs for convinience
type TradeItemInputList []TradeItemInput

func (tiil TradeItemInputList) String() string {
	itm := "TradeItemInputList{"

	for _, input := range tiil {
		itm += fmt.Sprintf("%+v", input) + ",\n"
	}

	itm += "}"
	return itm
}

// Validate is a function to check ItemInputList is valid
func (tiil TradeItemInputList) Validate() error {
	for _, ii := range tiil {
		if ii.CookbookID == "" {
			return errors.New("There should be no empty cookbook ID inputs for trades")
		}
	}
	return nil
}
