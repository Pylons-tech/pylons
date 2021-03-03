package queriers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// query endpoints supported by the nameservice Querier
const (
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
		NodeVersion: &trade.NodeVersion,
		ID:          trade.ID,
		CoinInputs:  &trade.CoinInputs,
		ItemInputs:  &trade.ItemInputs,
		CoinOutputs: trade.CoinOutputs,
		ItemOutputs: &trade.ItemOutputs,
		ExtraInfo:   trade.ExtraInfo,
		Sender:      trade.Sender.String(),
		FulFiller:   trade.FulFiller.String(),
		Disabled:    trade.Disabled,
		Completed:   trade.Completed,
	}, nil
}
