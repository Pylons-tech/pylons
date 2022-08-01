package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) Trade(c context.Context, req *v1beta1.QueryGetTradeRequest) (*v1beta1.QueryGetTradeResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	var trade v1beta1.Trade
	ctx := sdk.UnwrapSDKContext(c)

	if !k.HasTrade(ctx, req.Id) {
		return nil, sdkerrors.ErrKeyNotFound
	}

	store := prefix.NewStore(ctx.KVStore(k.storeKey), v1beta1.KeyPrefix(v1beta1.TradeKey))
	k.cdc.MustUnmarshal(store.Get(getTradeIDBytes(req.Id)), &trade)

	return &v1beta1.QueryGetTradeResponse{Trade: trade}, nil
}
