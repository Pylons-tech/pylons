package queriers

import (
	"context"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

// query endpoints supported by the nameservice Querier
const (
	KeyItemsBySender = "items_by_sender"
)

// ItemsBySender returns all items based on the sender address
func (querier *querierServer) ItemsBySender(ctx context.Context, req *types.ItemsBySenderRequest) (*types.ItemsBySenderResponse, error) {
	if req.Sender == "" {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "no sender is provided in path")
	}

	senderAddr, err := sdk.AccAddressFromBech32(req.Sender)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}
	items, err := querier.Keeper.GetItemsBySender(sdk.UnwrapSDKContext(ctx), senderAddr)

	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	return &types.ItemsBySenderResponse{
		Items: types.ItemInputsToProto(items),
	}, nil
}
