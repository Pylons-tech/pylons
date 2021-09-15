package keeper

import (
	"context"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) SetCookbookDenomMetadata(goCtx context.Context, msg *types.MsgSetCookbookDenomMetadata) (*types.MsgSetCookbookDenomMetadataResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	cookbook, found := k.GetCookbook(ctx, msg.CookbookID)
	if !found {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "cookbook with ID %s not found", msg.CookbookID)
	}

	// check if cookbook is owned by creator
	if msg.Creator != cookbook.Creator {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "cookbook with ID %s not owned by %s", msg.CookbookID, msg.Creator)
	}

	// build the denomUnits structure properly

	return &types.MsgSetCookbookDenomMetadataResponse{}, nil
}
