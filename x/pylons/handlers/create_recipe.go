package handlers

import (
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// HandlerMsgCreateRecipe is used to create cookbook by a developer
func HandlerMsgCreateRecipe(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgCreateRecipe) sdk.Result {

	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}

	recipe := types.NewRecipe(msg.CookbookName, msg.ID, msg.Inputs, msg.Outputs, 0)
	if err := keeper.SetRecipe(ctx, recipe); err != nil {
		return sdk.ErrInternal(err.Error()).Result()
	}

	return sdk.Result{}
}
