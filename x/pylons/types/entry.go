package types

import (
	"encoding/json"
	"fmt"
	"regexp"
)

// Entry describes an output which can be produced from a recipe
type Entry interface {
	GetID() string
	String() string
}

// EntryIDValidationError returns entry ID validation error
func EntryIDValidationError(ID string) error {
	regex := regexp.MustCompile(`^[a-zA-Z_][a-zA-Z_0-9]*$`)
	if regex.MatchString(ID) {
		return nil
	}

	return fmt.Errorf("entryID does not fit the regular expression ^[a-zA-Z_][a-zA-Z_0-9]*$: id=%s", ID)
}

// EntriesList is a struct to keep list of items and coins
type EntriesList []Entry

type serializeEntriesList struct {
	CoinOutputs       []CoinOutput
	ItemModifyOutputs []ItemModifyOutput
	ItemOutputs       []ItemOutput
}

func (wpl EntriesList) String() string {
	itm := "EntriesList{"

	for _, output := range wpl {
		itm += output.String() + ",\n"
	}

	itm += "}"
	return itm
}

// FindByID is a function to find an entry by ID
func (wpl EntriesList) FindByID(ID string) (Entry, error) {
	for _, wp := range wpl {
		if wp.GetID() == ID {
			return wp, nil
		}
	}
	return nil, fmt.Errorf("no entry with the ID %s available", ID)
}

// MarshalJSON is a custom marshal function
func (wpl EntriesList) MarshalJSON() ([]byte, error) {
	var sel serializeEntriesList
	for _, wp := range wpl {
		switch wp := wp.(type) {
		case CoinOutput:
			sel.CoinOutputs = append(sel.CoinOutputs, wp)
		case ItemModifyOutput:
			sel.ItemModifyOutputs = append(sel.ItemModifyOutputs, wp)
		case ItemOutput:
			sel.ItemOutputs = append(sel.ItemOutputs, wp)
		default:
		}
	}
	return json.Marshal(sel)
}

// UnmarshalJSON is a custom Unmarshal function
func (wpl *EntriesList) UnmarshalJSON(data []byte) error {
	var sel serializeEntriesList
	err := json.Unmarshal(data, &sel)
	if err != nil {
		return err
	}

	for _, co := range sel.CoinOutputs {
		*wpl = append(*wpl, co)
	}
	for _, io := range sel.ItemModifyOutputs {
		*wpl = append(*wpl, io)
	}
	for _, io := range sel.ItemOutputs {
		*wpl = append(*wpl, io)
	}
	return nil
}
