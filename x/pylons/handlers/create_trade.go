package handlers

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// CreateTradeResponse is struct of create trade response
type CreateTradeResponse struct {
	TradeID string `json:"TradeID"`
	Message string
	Status  string
}

// HandlerMsgCreateTrade is used to create a trade by a user
func HandlerMsgCreateTrade(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgCreateTrade) (*sdk.Result, error) {

	err := msg.ValidateBasic()
	if err != nil {
		return nil, errInternal(err)
	}

	for _, tii := range msg.ItemInputs {
		_, err := keeper.GetCookbook(ctx, tii.CookbookID)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, fmt.Sprintf("You specified a cookbook that does not exist where raw error is %+v", err))
		}
	}

	for _, item := range msg.ItemOutputs {
		itemFromStore, err := keeper.GetItem(ctx, item.ID)
		if err != nil {
			return nil, errInternal(err)
		}
		if !itemFromStore.Sender.Equals(msg.Sender) {
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, fmt.Sprintf("item with %s id is not owned by sender", item.ID))
		}
		if err = itemFromStore.NewTradeError(); err != nil {
			return nil, errInternal(fmt.Errorf("%s item id is not tradable", itemFromStore.ID))
		}
	}

	if !keeper.CoinKeeper.HasCoins(ctx, msg.Sender, msg.CoinOutputs) {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "sender doesn't have enough coins for the trade")
	}

	trade := types.NewTrade(msg.ExtraInfo,
		msg.CoinInputs,
		msg.ItemInputs,
		msg.CoinOutputs,
		msg.ItemOutputs,
		msg.Sender)
	if err := keeper.SetTrade(ctx, trade); err != nil {
		return nil, errInternal(err)
	}

	return marshalJSON(CreateTradeResponse{
		TradeID: trade.ID,
		Message: "successfully created a trade",
		Status:  "Success",
	})
}
