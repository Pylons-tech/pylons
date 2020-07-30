package queriers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyGetLockedCoinDetails = "get_locked_coin_details"
)

// GetLockedCoinDetails returns locked coins with details based on user
func GetLockedCoinDetails(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, error) {
	addr := path[0]
	accAddr, err := sdk.AccAddressFromBech32(addr)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	lcd := keeper.GetLockedCoinDetails(ctx, accAddr)

	lcl, err := keeper.Cdc.MarshalJSON(lcd)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return lcl, nil
}
