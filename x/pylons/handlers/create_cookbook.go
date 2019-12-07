package handlers

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

type CreateCBResponse struct {
	CookbookID string `json:"CookbookID"`
}

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

	if !keeper.CoinKeeper.HasCoins(ctx, msg.Sender, fee) {
		return sdk.ErrInsufficientCoins("the user doesn't have enough pylons").Result()
	}

	cpb := msgs.DefaultCostPerBlock
	if msg.CostPerBlock != nil {
		cpb = *msg.CostPerBlock
	}

	cb := types.NewCookbook(msg.SupportEmail, msg.Sender, msg.Version, msg.Name, msg.Description, msg.Developer, cpb)
	if err := keeper.SetCookbook(ctx, cb); err != nil {
		return errInternal(err)
	}

	mCookbook, err2 := json.Marshal(CreateCBResponse{
		cb.ID,
	})

	if err2 != nil {
		return errInternal(err2)
	}

	return sdk.Result{Data: mCookbook}
}
