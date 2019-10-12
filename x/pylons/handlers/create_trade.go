package handlers

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// HandlerMsgCreateTrade is used to create cookbook by a developer
func HandlerMsgCreateTrade(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgCreateTrade) sdk.Result {

	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}

	recipe := types.NewDefaultRecipe(msg.TradeName, "", msg.Description,
		msg.CoinInputs,
		msg.ItemInputs,
		msg.Entries,
		msg.BlockInterval, msg.Sender)
	if err := keeper.SetRecipe(ctx, recipe); err != nil {
		return sdk.ErrInternal(err.Error()).Result()
	}

	mRecipe, err2 := json.Marshal(map[string]string{
		"RecipeID": recipe.ID,
	})

	if err2 != nil {
		return sdk.ErrInternal(err2.Error()).Result()
	}

	return sdk.Result{Data: mRecipe}
}
