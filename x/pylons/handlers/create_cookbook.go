package handlers

import (
	"errors"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/config"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// CreateCookbookResponse is a struct of create cookbook response
type CreateCookbookResponse struct {
	CookbookID string `json:"CookbookID"`
	Message    string
	Status     string
}

// HandlerMsgCreateCookbook is used to create cookbook by a developer
func HandlerMsgCreateCookbook(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgCreateCookbook) (*sdk.Result, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	var fee sdk.Coins
	if msg.Level == types.BasicTier.Level {
		fee = types.BasicTier.Fee
	} else if msg.Level == types.PremiumTier.Level {
		fee = types.PremiumTier.Fee
	} else {
		return nil, errInternal(errors.New("invalid level"))
	}

	if !keeper.CoinKeeper.HasCoins(ctx, msg.Sender, fee) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "the user doesn't have enough pylons")
	}

	pylonsLLCAddress, err := sdk.AccAddressFromBech32(config.Config.Validators.PylonsLLC)
	if err != nil {
		return nil, errInternal(err)
	}
	err = keeper.CoinKeeper.SendCoins(ctx, msg.Sender, pylonsLLCAddress, fee)
	if err != nil {
		return nil, errInternal(err)
	}

	cpb := msgs.DefaultCostPerBlock
	if msg.CostPerBlock != nil {
		cpb = *msg.CostPerBlock
	}

	cb := types.NewCookbook(msg.SupportEmail, msg.Sender, msg.Version, msg.Name, msg.Description, msg.Developer, cpb)

	if msg.CookbookID != "" {
		if keeper.HasCookbook(ctx, msg.CookbookID) {
			return nil, errInternal(fmt.Errorf("A cookbook with CookbookID %s already exists", msg.CookbookID))
		}
		cb.ID = msg.CookbookID
	}

	if err := keeper.SetCookbook(ctx, cb); err != nil {
		return nil, errInternal(err)
	}

	return marshalJSON(CreateCookbookResponse{
		CookbookID: cb.ID,
		Message:    "successfully created a cookbook",
		Status:     "Success",
	})
}
