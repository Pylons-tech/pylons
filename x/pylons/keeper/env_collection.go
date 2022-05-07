package keeper

import (
	"fmt"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/google/cel-go/cel"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// NewCelEnvCollectionFromItem generate cel env collection for an item
func (k Keeper) NewCelEnvCollectionFromItem(ctx sdk.Context, recipeID, tradeID string, item types.Item) (types.CelEnvCollection, error) {
	varDefs := types.BasicVarDefs()
	variables := types.BasicVariables(ctx.BlockHeight(), recipeID, tradeID)
	varDefs, variables = types.AddVariableFromItem(varDefs, variables, "", item) // HP, level, attack

	funcs := cel.Functions()

	env, err := cel.NewEnv(
		cel.Declarations(
			varDefs...,
		),
	)
	if err != nil {
		return types.CelEnvCollection{}, err
	}

	ec := types.NewCelEnvCollection(env, variables, funcs)
	return ec, nil
}

// NewCelEnvCollectionFromRecipe generate cel env collection from recipe itemInputs
func (k Keeper) NewCelEnvCollectionFromRecipe(ctx sdk.Context, pendingExecution types.Execution, recipe types.Recipe) (types.CelEnvCollection, error) {
	// create environment variables from matched items
	varDefs := types.BasicVarDefs()
	variables := types.BasicVariables(ctx.BlockHeight(), recipe.ID, "")
	itemInputs := recipe.ItemInputs

	for idx, itemRecord := range pendingExecution.ItemInputs {
		iPrefix1 := fmt.Sprintf("input%d", idx) + "."
		item, found := k.GetItem(ctx, recipe.CookbookID, itemRecord.ID)
		if !found {
			return types.NewCelEnvCollection(nil, nil, nil), sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "itemRecord item not found in store")
		}

		if idx == 0 {
			// first matched item
			varDefs, variables = types.AddVariableFromItem(varDefs, variables, "", item) // HP, level, attack
		}

		varDefs, variables = types.AddVariableFromItem(varDefs, variables, iPrefix1, item) // input0.level, input1.attack, input2.HP
		if itemInputs[idx].ID != "" {
			iPrefix2 := itemInputs[idx].ID + "."
			varDefs, variables = types.AddVariableFromItem(varDefs, variables, iPrefix2, item) // sword.attack, monster.attack
		}
	}

	funcs := cel.Functions()

	env, err := cel.NewEnv(
		cel.Declarations(
			varDefs...,
		),
	)

	ec := types.NewCelEnvCollection(env, variables, funcs)
	return ec, err
}
