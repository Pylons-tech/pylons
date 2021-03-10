package queriers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// query endpoints supported by the nameservice Querier
const (
	KeyListTrade = "list_trade"
)

// ListTrade returns a trade based on the trade id
func (querier *querierServer) ListTrade(ctx context.Context, req *types.ListTradeRequest) (*types.ListTradeResponse, error) {

	var senderAccAddress sdk.AccAddress
	var err error

	if req.Size() != 0 {
		// an address has been provided
		senderAccAddress, err = sdk.AccAddressFromBech32(req.Address)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
	}

	trades, err := querier.Keeper.GetTradesByCreator(sdk.UnwrapSDKContext(ctx), senderAccAddress)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return &types.ListTradeResponse{
		Trades: trades,
	}, nil
}
