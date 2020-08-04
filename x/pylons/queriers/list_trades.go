package queriers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyListTrade = "list_trade"
)

// ListTrade returns a trade based on the trade id
func ListTrade(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, error) {

	var senderAccAddress sdk.AccAddress
	var err error

	if len(path) != 0 {
		// an address has been provided
		addr := path[0]
		senderAccAddress, err = sdk.AccAddressFromBech32(addr)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
	}

	trades, err := keeper.GetTradesByCreator(ctx, senderAccAddress)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	tradeList := types.TradeList{
		Trades: trades,
	}

	rcpl, err := keeper.Cdc.MarshalJSON(tradeList)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return rcpl, nil
}
