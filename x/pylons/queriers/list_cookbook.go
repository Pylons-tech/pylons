package queriers

import (
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyListCookbook = "list_cookbook"
)

// ListCookbook returns a cookbook based on the cookbook id
func ListCookbook(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, sdk.Error) {
	addr := path[0]
	var cookbookList types.CookbookList
	var cookbooks []types.Cookbook
	accAddr, err := sdk.AccAddressFromBech32(addr)

	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	iterator := keeper.GetCookbooksIterator(ctx, accAddr)

	for ; iterator.Valid(); iterator.Next() {
		var cookbook types.Cookbook
		mCB := iterator.Value()
		err = keeper.Cdc.UnmarshalBinaryBare(mCB, &cookbook)
		if err != nil {
			return nil, sdk.ErrInternal(err.Error())
		}

		cookbooks = append(cookbooks, cookbook)
	}

	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	cookbookList = types.CookbookList{
		Cookbooks: cookbooks,
	}

	cbl, err := keeper.Cdc.MarshalBinaryBare(cookbookList)
	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	return cbl, nil
}
