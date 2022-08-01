package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) ListSignUpByReferee(c context.Context, req *v1beta1.QueryListSignUpByReferee) (*v1beta1.QueryListSignUpByRefereeResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	ctx := sdk.UnwrapSDKContext(c)

	val, found := k.GetPylonsReferral(ctx, req.Creator)
	if !found {
		return nil, sdkerrors.ErrKeyNotFound
	}

	return &v1beta1.QueryListSignUpByRefereeResponse{Signup: &val}, nil
}
