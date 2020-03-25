package types

import (
	"encoding/json"
)

// Entry describes an output which can be produced from a recipe
type Entry interface {
	String() string
}

// EntriesList is a struct to keep list of items and coins
type EntriesList []Entry

type serializeEntriesList struct {
	CoinOutputs []CoinOutput
	ItemOutputs []ItemOutput
}

func (wpl EntriesList) String() string {
	itm := "EntriesList{"

	for _, output := range wpl {
		itm += output.String() + ",\n"
	}

	itm += "}"
	return itm
}

func (wpl EntriesList) MarshalJSON() ([]byte, error) {
	var sel serializeEntriesList
	for _, wp := range wpl {
		switch wp.(type) {
		case CoinOutput:
			if coinOutput, ok := wp.(CoinOutput); ok {
				sel.CoinOutputs = append(sel.CoinOutputs, coinOutput)
			}
		case ItemOutput:
			if itemOutput, ok := wp.(ItemOutput); ok {
				sel.ItemOutputs = append(sel.ItemOutputs, itemOutput)
			}
		default:
		}
	}
	return json.Marshal(sel)
}

func (el *EntriesList) UnmarshalJSON(data []byte) error {
	var sel serializeEntriesList
	err := json.Unmarshal(data, &sel)
	if err != nil {
		return err
	}

	for _, co := range sel.CoinOutputs {
		*el = append(*el, co)
	}
	for _, io := range sel.ItemOutputs {
		*el = append(*el, io)
	}
	return nil
}
