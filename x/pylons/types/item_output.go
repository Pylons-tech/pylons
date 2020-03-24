package types

import (
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
