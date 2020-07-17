package handlers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// GetPylonsResponse is the response for get-pylons
type GetPylonsResponse struct {
	Message string
	Status  string
}

// HandlerMsgGetPylons is used to send pylons to requesters. This handler is part of the
// faucet
func HandlerMsgGetPylons(ctx sdk.Context, keeper keep.Keeper, msg msgs.MsgGetPylons) (*sdk.Result, error) {

	err := msg.ValidateBasic()

	if err != nil {
		return nil, errInternal(err)
	}

	// TODO: validate if purchase token does exist within the list already
	// TODO: register purchase token before giving coins, put the data where the entityCount or cookbooks are stored.
	// TODO: filter pylons out of all the coins
	_, err = keeper.CoinKeeper.AddCoins(ctx, msg.Requester, msg.Amount) // If so, deduct the Bid amount from the sender
	// TODO, for now, we don't verify the package name and amount match as we need to discuss how to handle this
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInsufficientFunds, "Buyer does not have enough coins")
	}

	return marshalJSON(GetPylonsResponse{
		Message: "successfully got the pylons",
		Status:  "Success",
	})
}
