package queriers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	sdk "github.com/cosmos/cosmos-sdk/types"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyGetItem = "get_item"
)

// GetItem returns a item based on the item id
func GetItem(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, sdk.Error) {
	if len(path) == 0 {
		return nil, sdk.ErrInternal("no item id is provided in path")
	}
	itemID := path[0]
	item, err := keeper.GetItem(ctx, itemID)

	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}
	// if we cannot find the value then it should return an error
	bz, err := keeper.Cdc.MarshalJSON(item)
	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	return bz, nil

}
