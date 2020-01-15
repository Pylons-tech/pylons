package queriers

import (
	"encoding/json"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
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

func (ir ItemResp) String() string {
	output := "ItemResp{"
	for _, it := range ir.Items {
		output += it.String()
		output += ",\n"
	}
	output += "}"
	return output
}

// ItemsByCookbook returns a cookbook based on the cookbook id
func ItemsByCookbook(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, sdk.Error) {
	if len(path) == 0 {
		return nil, sdk.ErrInternal("no cookbook id is provided in path")
	}
	cookbookID := path[0]
	items, err := keeper.ItemsByCookbook(ctx, cookbookID)

	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	itemResp := ItemResp{
		Items: items,
	}

	// if we cannot find the value then it should return an error
	mItems, err := json.Marshal(itemResp)
	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	return mItems, nil
}
