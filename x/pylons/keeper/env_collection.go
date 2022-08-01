package keeper

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/google/cel-go/cel"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

// NewCelEnvCollectionFromItem generate cel env collection for an item
func (k Keeper) NewCelEnvCollectionFromItem(ctx sdk.Context, recipeID, tradeID string, item v1beta1.Item) (v1beta1.CelEnvCollection, error) {
	varDefs := v1beta1.BasicVarDefs()
	variables := v1beta1.BasicVariables(ctx.BlockHeight(), recipeID, tradeID)
	varDefs, variables = v1beta1.AddVariableFromItem(varDefs, variables, "", item) // HP, level, attack

	funcs := cel.Functions() //nolint:staticcheck // TODO: FIX THIS VIA A REFACTOR OF THIS LINE, WHICH WILL INVOLVE MORE CODE.

	env, err := cel.NewEnv(
		cel.Declarations(
			varDefs...,
		),
	)
	if err != nil {
		return v1beta1.CelEnvCollection{}, err
	}

	ec := v1beta1.NewCelEnvCollection(env, variables, funcs)
	return ec, nil
}

// NewCelEnvCollectionFromRecipe generate cel env collection from recipe itemInputs
func (k Keeper) NewCelEnvCollectionFromRecipe(ctx sdk.Context, pendingExecution v1beta1.Execution, recipe v1beta1.Recipe) (v1beta1.CelEnvCollection, error) {
	// create environment variables from matched items
	varDefs := v1beta1.BasicVarDefs()
	variables := v1beta1.BasicVariables(ctx.BlockHeight(), recipe.Id, "")
	itemInputs := recipe.ItemInputs

	for idx, itemRecord := range pendingExecution.ItemInputs {
		iPrefix1 := fmt.Sprintf("input%d", idx) + "."
		item, found := k.GetItem(ctx, recipe.CookbookId, itemRecord.Id)
		if !found {
			return v1beta1.NewCelEnvCollection(nil, nil, nil), sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "itemRecord item not found in store")
		}

		if idx == 0 {
			// first matched item
			varDefs, variables = v1beta1.AddVariableFromItem(varDefs, variables, "", item) // HP, level, attack
		}

		varDefs, variables = v1beta1.AddVariableFromItem(varDefs, variables, iPrefix1, item) // input0.level, input1.attack, input2.HP
		if itemInputs[idx].Id != "" {
			iPrefix2 := itemInputs[idx].Id + "."
			varDefs, variables = v1beta1.AddVariableFromItem(varDefs, variables, iPrefix2, item) // sword.attack, monster.attack
		}
	}

	funcs := cel.Functions() //nolint:staticcheck // TODO: FIX THIS VIA A REFACTOR OF THIS LINE, WHICH WILL REQUIRE MORE CODE

	env, err := cel.NewEnv(
		cel.Declarations(
			varDefs...,
		),
	)

	ec := v1beta1.NewCelEnvCollection(env, variables, funcs)
	return ec, err
}
