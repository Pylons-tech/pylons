package queriers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyGetLockedCoin = "get_locked_coins"
)

// GetLockedCoins returns locked coins based on user
func GetLockedCoins(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, error) {
	addr := path[0]
	accAddr, err := sdk.AccAddressFromBech32(addr)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	lc := keeper.GetLockedCoin(ctx, accAddr)

	lcl, err := keeper.Cdc.MarshalJSON(lc)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return lcl, nil
}
