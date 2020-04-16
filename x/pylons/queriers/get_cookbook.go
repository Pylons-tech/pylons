package queriers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyGetCookbook = "get_cookbook"
)

// GetCookbook returns a cookbook based on the cookbook id
func GetCookbook(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, error) {
	if len(path) == 0 {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no cookbook id is provided in path")
	}
	cookbookID := path[0]
	cookbook, err := keeper.GetCookbook(ctx, cookbookID)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}
	// if we cannot find the value then it should return an error
	bz, err := keeper.Cdc.MarshalJSON(cookbook)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return bz, nil

}
