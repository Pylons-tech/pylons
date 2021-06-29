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
func EntryIDValidationError(id string) error {
	regex := regexp.MustCompile(`^[a-zA-Z_][a-zA-Z_0-9]*$`)
	if regex.MatchString(id) {
		return nil
	}

	return fmt.Errorf("entryID does not fit the regular expression ^[a-zA-Z_][a-zA-Z_0-9]*$: id=%s", id)
}

type serializeEntriesList struct {
	CoinOutputs       []CoinOutput
	ItemModifyOutputs []ItemModifyOutput
	ItemOutputs       []ItemOutput
}

// FindByID is a function to find an entry by ID
func (wpl EntriesList) FindByID(id string) (EntryI, error) {
	for _, wp := range wpl.CoinOutputs {
		if wp.GetID() == id {
			return &wp, nil
		}
	}

	for _, wp := range wpl.ItemOutputs {
		if wp.GetID() == id {
			return &wp, nil
		}
	}

	for _, wp := range wpl.ItemModifyOutputs {
		if wp.GetID() == id {
			return &wp, nil
		}
	}
	return nil, fmt.Errorf("no entry with the ID %s available", id)
}

// MarshalJSON is a custom marshal function
func (wpl EntriesList) MarshalJSON() ([]byte, error) {
	var sel serializeEntriesList
	sel.CoinOutputs = append(sel.CoinOutputs, wpl.CoinOutputs...)
	sel.ItemModifyOutputs = append(sel.ItemModifyOutputs, wpl.ItemModifyOutputs...)
	sel.ItemOutputs = append(sel.ItemOutputs, wpl.ItemOutputs...)

	return json.Marshal(sel)
}

// UnmarshalJSON is a custom Unmarshal function
func (wpl *EntriesList) UnmarshalJSON(data []byte) error {
	var sel serializeEntriesList
	err := json.Unmarshal(data, &sel)
	if err != nil {
		return err
	}

	wpl.CoinOutputs = append(wpl.CoinOutputs, sel.CoinOutputs...)
	wpl.ItemModifyOutputs = append(wpl.ItemModifyOutputs, sel.ItemModifyOutputs...)
	wpl.ItemOutputs = append(wpl.ItemOutputs, sel.ItemOutputs...)

	return nil
}
