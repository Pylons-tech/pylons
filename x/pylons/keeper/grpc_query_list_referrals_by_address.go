package keeper

import (
	"context"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) ListSignUpByReferee(c context.Context, req *types.QueryListSignUpByReferee) (*types.QueryListSignUpByRefereeResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(c)

	val, found := k.GetPylonsReferral(ctx, req.Creator)
	if !found {
		return nil, sdkerrors.ErrKeyNotFound
	}

	return &types.QueryListSignUpByRefereeResponse{Signup: &val}, nil
}
