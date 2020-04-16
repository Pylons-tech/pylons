package queriers

import (
	"encoding/json"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	abci "github.com/tendermint/tendermint/abci/types"

	db "github.com/tendermint/tm-db"
)

// query endpoints supported by the nameservice Querier
const (
	KeyListTrade = "list_trade"
)

// ListTrade returns a trade based on the trade id
func ListTrade(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, error) {

	var tradeList types.TradeList
	var trades []types.Trade
	var iterator db.Iterator

	if len(path) != 0 {
		// an address has been provided
		addr := path[0]
		senderAccAddress, err := sdk.AccAddressFromBech32(addr)
		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
		iterator = keeper.GetTradesIteratorByCreator(ctx, senderAccAddress)
	} else {
		// get all trades
		iterator = keeper.GetTradesIterator(ctx)
	}

	for ; iterator.Valid(); iterator.Next() {
		var trade types.Trade
		mRCP := iterator.Value()
		err := json.Unmarshal(mRCP, &trade)
		if err != nil {
			// this happens because we have multiple versions of breaking trades at times
			continue
		}

		if !trade.Disabled {
			trades = append(trades, trade)
		}
	}

	tradeList = types.TradeList{
		Trades: trades,
	}

	rcpl, err := keeper.Cdc.MarshalJSON(tradeList)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return rcpl, nil
}
