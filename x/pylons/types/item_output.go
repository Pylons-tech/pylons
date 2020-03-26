package types

import (
	"encoding/json"
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/google/cel-go/cel"
)

// ItemOutput models the continuum of valid outcomes for item generation in recipes
type ItemOutput struct {
	ItemInputRef int
	ToModify     ItemModifyParams
	Doubles      DoubleParamList
	Longs        LongParamList
	Strings      StringParamList
}

type SerializeItemOutput struct {
	ItemInputRef *int `json:",omitempty"`
	ToModify     ItemModifyParams
	Doubles      DoubleParamList
	Longs        LongParamList
	Strings      StringParamList
}

func (io ItemOutput) String() string {
	return fmt.Sprintf(`ItemOutput{
		ItemInputRef: %d,
		ToModify: %+v,
		Doubles: %+v,
		Longs:   %+v,
		Strings: %+v,
	}`, io.ItemInputRef, io.ToModify, io.Doubles, io.Longs, io.Strings)
}

func (io ItemOutput) Item(cookbook string, sender sdk.AccAddress, env cel.Env, variables map[string]interface{}, funcs cel.ProgramOption) (*Item, error) {
	// This function is used on ExecuteRecipe's AddExecutedResult, and it's
	// not acceptable to provide predefined GUID
	dblActualize, err := io.Doubles.Actualize(env, variables, funcs)
	if err != nil {
		return nil, err
	}
	longActualize, err := io.Longs.Actualize(env, variables, funcs)
	if err != nil {
		return nil, err
	}
	stringActualize, err := io.Strings.Actualize(env, variables, funcs)
	if err != nil {
		return nil, err
	}

	return NewItem(cookbook, dblActualize, longActualize, stringActualize, sender), nil
}

func (io *ItemOutput) MarshalJSON() ([]byte, error) {
	sio := SerializeItemOutput{
		ItemInputRef: nil,
		ToModify:     io.ToModify,
		Doubles:      io.Doubles,
		Longs:        io.Longs,
		Strings:      io.Strings,
	}
	if io.ItemInputRef != 0 {
		sio.ItemInputRef = &io.ItemInputRef
	}
	return json.Marshal(sio)
}

func (io *ItemOutput) UnmarshalJSON(data []byte) error {
	sio := SerializeItemOutput{}
	err := json.Unmarshal(data, &sio)
	if err != nil {
		return err
	}
	if sio.ItemInputRef == nil {
		io.ItemInputRef = 0
	} else {
		io.ItemInputRef = *sio.ItemInputRef
	}
	io.ToModify = sio.ToModify
	io.Doubles = sio.Doubles
	io.Longs = sio.Longs
	io.Strings = sio.Strings
	return nil
}
