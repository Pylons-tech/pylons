package queriers

import (
	"encoding/json"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyListTrade = "list_trade"
)

// ListTrade returns a trade based on the trade id
func ListTrade(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, sdk.Error) {

	var tradeList types.TradeList
	var trades []types.Trade
	iterator := keeper.GetTradesIterator(ctx)

	for ; iterator.Valid(); iterator.Next() {
		var trade types.Trade
		mRCP := iterator.Value()
		err := json.Unmarshal(mRCP, &trade)
		if err != nil {
			// this happens because we have multiple versions of breaking trades at times
			continue
		}

		trades = append(trades, trade)
	}

	tradeList = types.TradeList{
		Trades: trades,
	}

	rcpl, err := keeper.Cdc.MarshalJSON(tradeList)
	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	return rcpl, nil
}
