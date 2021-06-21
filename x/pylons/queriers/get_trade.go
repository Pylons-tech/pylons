package queriers

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

const (
	// KeyGetTrade is a query endpoint supported by the nameservice Querier
	KeyGetTrade = "get_trade"
)

// GetTrade returns a trade based on the trade id
func (querier *querierServer) GetTrade(ctx context.Context, req *types.GetTradeRequest) (*types.GetTradeResponse, error) {
	if req.TradeID == "" {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no trade id is provided in path")
	}

	trade, err := querier.Keeper.GetTrade(sdk.UnwrapSDKContext(ctx), req.TradeID)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return &types.GetTradeResponse{
		NodeVersion: trade.NodeVersion,
		ID:          trade.ID,
		CoinInputs:  trade.CoinInputs,
		ItemInputs:  trade.ItemInputs,
		CoinOutputs: trade.CoinOutputs,
		ItemOutputs: trade.ItemOutputs,
		ExtraInfo:   trade.ExtraInfo,
		Sender:      trade.Sender,
		FulFiller:   trade.FulFiller,
		Disabled:    trade.Disabled,
		Completed:   trade.Completed,
	}, nil
}

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
