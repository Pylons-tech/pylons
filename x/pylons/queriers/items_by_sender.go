package queriers

import (
	"encoding/json"
	
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	sdk "github.com/cosmos/cosmos-sdk/types"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyItemsBySender = "items_by_sender"
)

// ItemsBySender returns a cookbook based on the sender address
func ItemsBySender(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, sdk.Error) {
	if len(path) == 0 {
		return nil, sdk.ErrInternal("no cookbook id is provided in path")
	}
	sender := path[0]
	senderAddr, err := sdk.AccAddressFromBech32(sender)

	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}
	items, err := keeper.GetItemsBySender(ctx, senderAddr)

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
