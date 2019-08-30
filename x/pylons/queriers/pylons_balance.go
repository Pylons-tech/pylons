package queriers

import (
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyPylonsBalance = "balance"
)

// PylonsBalance provides balances in pylons
func PylonsBalance(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) (res []byte, err sdk.Error) {
	addr := path[0]
	accAddr, err1 := sdk.AccAddressFromBech32(addr)

	if err1 != nil {
		return []byte{}, sdk.ErrInternal(err1.Error())
	}
	coins := keeper.CoinKeeper.GetCoins(ctx, accAddr)

	var value int64
	for _, coin := range coins {
		if coin.Denom == types.Pylon {
			value = coin.Amount.Int64()
			break
		}
	}

	// if we cannot find the value then it should return as 0
	bz, err2 := keeper.Cdc.MarshalJSON(QueryResBalance{value})
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
