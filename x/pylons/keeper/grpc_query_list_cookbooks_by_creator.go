package keeper

import (
	"context"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) ListCookbooksByCreator(goCtx context.Context, req *types.QueryListCookbooksByCreatorRequest) (*types.QueryListCookbooksByCreatorResponse, error) {
	var err error
	var addr sdk.AccAddress

	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(goCtx)

	if req.Creator != "" {
		addr, err = sdk.AccAddressFromBech32(req.Creator)

		if err != nil {
			return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
	}
	cbs := k.GetAllCookbookByCreator(ctx, addr)

	return &types.QueryListCookbooksByCreatorResponse{Cookbooks: cbs}, nil
}
