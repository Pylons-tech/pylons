package pylons

import (
	"github.com/cosmos/cosmos-sdk/codec"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	sdk "github.com/cosmos/cosmos-sdk/types"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	QueryBalance = "balance"
)

// NewQuerier is the module level router for state queries
func NewQuerier(keeper keep.Keeper) sdk.Querier {
	return func(ctx sdk.Context, path []string, req abci.RequestQuery) (res []byte, err sdk.Error) {
		switch path[0] {
		case QueryBalance:
			return queryBalance(ctx, path[1:], req, keeper)
		default:
			return nil, sdk.ErrUnknownRequest("unknown pylons query endpoint")
		}
	}
}

// nolint: unparam
func queryBalance(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) (res []byte, err sdk.Error) {
	addr := path[0]
	accAddr, err1 := sdk.AccAddressFromBech32(addr)

	if err1 != nil {
		return []byte{}, sdk.ErrInternal(err1.Error())
	}
	coins := keeper.CoinKeeper.GetCoins(ctx, accAddr)

	var value int64
	for _, coin := range coins {
		if coin.Denom == Pylon {
			value = coin.Amount.Int64()
			break
		}
	}

	// if we cannot find the value then it should return as 0
	bz, err2 := codec.MarshalJSONIndent(keeper.Cdc, QueryResBalance{value})
	if err2 != nil {
		panic("could not marshal result to JSON")
	}

	return bz, nil

}

// QueryResBalance Result Payload for a resolve query
type QueryResBalance struct {
	Balance int64 `json:"balance"`
}

// implement fmt.Stringer
func (r QueryResBalance) String() string {
	return string(r.Balance)
}
