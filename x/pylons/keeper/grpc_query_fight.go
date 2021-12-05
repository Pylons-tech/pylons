package keeper

import (
	"context"
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/store/prefix"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"
)

func (k Keeper) Fight(goCtx context.Context, req *types.QueryFightRequest) (*types.QueryFightResponse, error) {
	if req == nil {
		return nil, status.Error(codes.InvalidArgument, "invalid request")
	}

	fmt.Println("ID:", req.ID)
	var fighter types.Fighter
	ctx := sdk.UnwrapSDKContext(goCtx)

	if !k.HasFighter(ctx, req.ID) {
		return nil, sdkerrors.ErrKeyNotFound
	}

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.FighterKey))
	k.cdc.MustUnmarshal(store.Get(getFighterIDBytes(req.ID)), &fighter)

	fmt.Println("FIGHTER", fighter)
	return &types.QueryFightResponse{Fighter: fighter}, nil
}
