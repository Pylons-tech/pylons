package keeper

import (
	"context"

	errorsmod "cosmossdk.io/errors"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/epochs/types"
)

var _ types.QueryServer = Keeper{}

// EpochInfos provide running epochInfos
func (k Keeper) EpochInfos(c context.Context, _ *types.QueryEpochsInfoRequest) (*types.QueryEpochsInfoResponse, error) {
	ctx := sdk.UnwrapSDKContext(c)

	return &types.QueryEpochsInfoResponse{
		Epochs: k.AllEpochInfos(ctx),
	}, nil
}

// CurrentEpoch provides current epoch of specified identifier
func (k Keeper) CurrentEpoch(c context.Context, req *types.QueryCurrentEpochRequest) (*types.QueryCurrentEpochResponse, error) {
	ctx := sdk.UnwrapSDKContext(c)

	info := k.GetEpochInfo(ctx, req.Identifier)
	if info.Identifier != req.Identifier {
		return nil, errorsmod.Wrap(sdkerrors.ErrInvalidRequest, "not available identifier")
	}

	return &types.QueryCurrentEpochResponse{
		CurrentEpoch: info.CurrentEpoch,
	}, nil
}
