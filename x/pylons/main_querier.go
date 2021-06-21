package pylons

import (
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	abci "github.com/tendermint/tendermint/abci/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// NewQuerier is the module level router for state queries
func NewQuerier(keeper keeper.Keeper) sdk.Querier {
	return func(ctx sdk.Context, path []string, req abci.RequestQuery) (res []byte, err error) {
		if len(path) < 1 {
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "no endpoint path provided for pylons query")
		}
		switch path[0] {
		default:
			return nil, sdkerrors.Wrap(sdkerrors.ErrUnknownRequest, "unknown pylons query endpoint")
		}
	}
}
