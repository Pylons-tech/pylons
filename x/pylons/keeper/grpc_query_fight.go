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

	var fighter types.Fighter
	ctx := sdk.UnwrapSDKContext(goCtx)

	if !k.HasFighter(ctx, req.ID) {
		return nil, sdkerrors.ErrKeyNotFound
	}

	store := prefix.NewStore(ctx.KVStore(k.storeKey), types.KeyPrefix(types.FighterKey))
	k.cdc.MustUnmarshal(store.Get(getTradeIDBytes(req.ID)), &fighter)


	/*
	id, err := strconv.ParseUint(req.Id, 10, 64)
	if err != nil {
		// Panic because the count should be always formattable to uint64
		panic("cannot decode id")
	}
	fighter := k.GetFighter(ctx, id)
	*/

	fmt.Println("YEES")
	fmt.Println(fighter)

	return &types.QueryFightResponse{Fighter: fighter}, nil
}
