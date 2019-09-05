package queriers

import (
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyItemsByCookbook = "items_by_cookbook"
)

// ItemResp is the response for Items
type ItemResp struct {
	Items []types.Item
}

// ItemsByCookbook returns a cookbook based on the cookbook id
func ItemsByCookbook(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, sdk.Error) {
	cookbookID := path[0]
	items, err := keeper.ItemsByCookbook(ctx, cookbookID)

	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	itemResp := ItemResp{
		Items: items,
	}

	// if we cannot find the value then it should return an error
	mItems, err := keeper.Cdc.MarshalJSON(itemResp)
	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	return mItems, nil

}
