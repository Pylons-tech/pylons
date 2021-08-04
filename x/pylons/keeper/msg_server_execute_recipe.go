package keeper

import (
	"context"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) ExecuteRecipe(goCtx context.Context, msg *types.MsgExecuteRecipe) (*types.MsgExecuteRecipeResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	// TODO: Handling the message
	_ = ctx

	// nested for loop foreach item in msg.InputItemIDs foreach recipe.ItemInput
	//		all recipe.ItemInput have to match one item in msg.InputItemIDs
	// 		match: all Keys in recipe.ItemInput have to exist on msg.ItemInputs[i] and Value need to be within the range
	//   output: map to associate items in  msg.InputItemIDs to the corresponding index of the item in the list recipe.ItemInput

	// check that user has balance to cover recipe.CoinInputs
	// if true, lock these coins

	// create PendingExecution passing the current blockHeight

	return &types.MsgExecuteRecipeResponse{}, nil
}
