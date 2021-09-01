package keeper

import (
	"context"

	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) Trade(c context.Context, req *types.QueryGetTradeRequest) (*types.QueryGetTradeResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	var trade types.Trade
	ctx := sdk.UnwrapSDKContext(c)

	if !k.HasTrade(ctx, req.ID) {
		return nil, sdkerrors.ErrKeyNotFound
	}

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.TradeKey))
	k.cdc.MustUnmarshalBinaryBare(store.Get(GetTradeIDBytes(req.ID)), &trade)

	return &types.QueryGetTradeResponse{Trade: &trade}, nil
}
