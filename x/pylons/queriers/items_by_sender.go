package queriers

import (
	"github.com/MikeSofaer/pylons/x/pylons/keep"
	sdk "github.com/cosmos/cosmos-sdk/types"
	abci "github.com/tendermint/tendermint/abci/types"
)

// query endpoints supported by the nameservice Querier
const (
	KeyItemsBySender = "items_by_sender"
)

// GetItemsBySender returns a cookbook based on the sender address
func GetItemsBySender(ctx sdk.Context, path []string, req abci.RequestQuery, keeper keep.Keeper) ([]byte, sdk.Error) {
	sender := path[0]
	senderAddr, err := sdk.AccAddressFromBech32(sender)

	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}
	items, err := keeper.GetItemsBySender(ctx, senderAddr)

	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}
	// if we cannot find the value then it should return an error
	mItems, err := keeper.Cdc.MarshalJSON(items)
	if err != nil {
		return nil, sdk.ErrInternal(err.Error())
	}

	return mItems, nil

}
