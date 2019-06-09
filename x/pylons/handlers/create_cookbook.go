package handlers

import (
	"fmt"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// HandlerMsgCreateCookbook is used to create cookbook by a developer
func HandlerMsgCreateCookbook(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgCreateCookbook) sdk.Result {

	err := msg.ValidateBasic()
	if err != nil {
		return err.Result()
	}

	var fee sdk.Coins
	if msg.Level == types.BasicTier.Level {
		fee = types.BasicTier.Fee
	} else if msg.Level == types.PremiumTier.Level {
		fee = types.PremiumTier.Fee
	} else {
		return sdk.ErrInternal("invalid level").Result()
	}
	fmt.Println(fee)
	return sdk.Result{}
}
