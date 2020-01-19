package queriers

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyListCookbook = "list_cookbook"
)

// ListCookbook returns a cookbook based on the cookbook id
func ListCookbook(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, sdk.Error) {
	if len(path) == 0 {
		return nil, sdk.ErrInternal("no address is provided in path")
	}
	addr := path[0]
	var cookbookList types.CookbookList
	accAddr, err := sdk.AccAddressFromBech32(addr)

	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	cookbooks, err := keeper.GetCookbookBySender(ctx, accAddr)
	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	cookbookList = types.CookbookList{
		Cookbooks: cookbooks,
	}

	cbl, err := keeper.Cdc.MarshalJSON(cookbookList)
	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	return cbl, nil
}
