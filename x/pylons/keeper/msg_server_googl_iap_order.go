package keeper

import (
    "fmt"
	"context"

    "github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)


func (k msgServer) CreateGooglIAPOrder(goCtx context.Context,  msg *types.MsgCreateGooglIAPOrder) (*types.MsgCreateGooglIAPOrderResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

    var googlIAPOrder = types.GooglIAPOrder{
        Creator: msg.Creator,
        ProductID: msg.ProductID,
        PurchaseToken: msg.PurchaseToken,
        ReceiptDaBase64: msg.ReceiptDaBase64,
        Signature: msg.Signature,
    }

    id := k.AppendGooglIAPOrder(
        ctx,
        googlIAPOrder,
    )

	return &types.MsgCreateGooglIAPOrderResponse{
	    Id: id,
	}, nil
}

func (k msgServer) UpdateGooglIAPOrder(goCtx context.Context,  msg *types.MsgUpdateGooglIAPOrder) (*types.MsgUpdateGooglIAPOrderResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

    var googlIAPOrder = types.GooglIAPOrder{
		Creator: msg.Creator,
		Id:      msg.Id,
    	ProductID: msg.ProductID,
    	PurchaseToken: msg.PurchaseToken,
    	ReceiptDaBase64: msg.ReceiptDaBase64,
    	Signature: msg.Signature,
	}

    // Checks that the element exists
    if !k.HasGoogleIAPOrder(ctx, msg.Id) {
        return nil, sdkerrors.Wrap(sdkerrors.ErrKeyNotFound, fmt.Sprintf("key %d doesn't exist", msg.Id))
    }

    // Checks if the the msg sender is the same as the current owner
    if msg.Creator != k.GetGoogleIAPOrderOwner(ctx, msg.Id) {
        return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "incorrect owner")
    }

	k.SetGoogleIAPOrder(ctx, googlIAPOrder)

	return &types.MsgUpdateGooglIAPOrderResponse{}, nil
}

func (k msgServer) DeleteGooglIAPOrder(goCtx context.Context,  msg *types.MsgDeleteGooglIAPOrder) (*types.MsgDeleteGooglIAPOrderResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

    if !k.HasGoogleIAPOrder(ctx, msg.Id) {
        return nil, sdkerrors.Wrap(sdkerrors.ErrKeyNotFound, fmt.Sprintf("key %d doesn't exist", msg.Id))
    }
    if msg.Creator != k.GetGoogleIAPOrderOwner(ctx, msg.Id) {
        return nil, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "incorrect owner")
    }

	k.RemoveGoogleIAPOrder(ctx, msg.Id)

	return &types.MsgDeleteGooglIAPOrderResponse{}, nil
}
