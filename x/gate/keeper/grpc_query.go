package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/gate/types"
)

var _ types.QueryServer = Keeper{}

func (k Keeper) MaxTxsPerBlock(ctx context.Context, req *types.QueryMaxTxsPerBlockRequest) (*types.QueryMaxTxsPerBlockResponse, error) {
	return &types.QueryMaxTxsPerBlockResponse{}, types.ErrNotImplemented
}
