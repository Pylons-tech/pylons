package handlers

import (
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// HandlerMsgCreateCookbook is used to create cookbook by a developer
func HandlerMsgCreateCookbook(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgCreateCookbook) sdk.Result {

	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}

	return sdk.Result{}
}
