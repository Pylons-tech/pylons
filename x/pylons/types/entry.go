package types

import (
	"encoding/json"
	"fmt"
	"regexp"
)

// Entry describes an output which can be produced from a recipe
type EntryI interface {
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

type serializeEntriesList struct {
	CoinOutputs       []CoinOutput
	ItemModifyOutputs []ItemModifyOutput
	ItemOutputs       []ItemOutput
}

// FindByID is a function to find an entry by ID
func (wpl EntriesList) FindByID(ID string) (EntryI, error) {
	for _, wp := range wpl.CoinOutputs {
		if wp.GetID() == ID {
			return wp, nil
		}
	}

	for _, wp := range wpl.ItemOutputs {
		if wp.GetID() == ID {
			return wp, nil
		}
	}

	for _, wp := range wpl.ItemModifyOutputs {
		if wp.GetID() == ID {
			return wp, nil
		}
	}
	return nil, fmt.Errorf("no entry with the ID %s available", ID)
}

// MarshalJSON is a custom marshal function
func (wpl EntriesList) MarshalJSON() ([]byte, error) {
	var sel serializeEntriesList
	for _, wp := range wpl.CoinOutputs {
		sel.CoinOutputs = append(sel.CoinOutputs, *wp)
	}
	for _, wp := range wpl.ItemModifyOutputs {
		sel.ItemModifyOutputs = append(sel.ItemModifyOutputs, *wp)
	}
	for _, wp := range wpl.ItemOutputs {
		sel.ItemOutputs = append(sel.ItemOutputs, *wp)
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
		wpl.CoinOutputs = append(wpl.CoinOutputs, &co)
	}
	for _, io := range sel.ItemModifyOutputs {
		wpl.ItemModifyOutputs = append(wpl.ItemModifyOutputs, &io)
	}
	for _, io := range sel.ItemOutputs {
		wpl.ItemOutputs = append(wpl.ItemOutputs, &io)
	}
	return nil
}
