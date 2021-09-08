package keeper

import (
	"context"

	"github.com/cosmos/cosmos-sdk/telemetry"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) CreateAccount(goCtx context.Context, msg *types.MsgCreateAccount) (*types.MsgCreateAccountResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	addr, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "unable to derive address from bech32 string")
	}
	acc := k.accountKeeper.GetAccount(ctx, addr)
	if acc == nil {
		defer telemetry.IncrCounter(1, "new", "account")
		k.accountKeeper.SetAccount(ctx, k.accountKeeper.NewAccountWithAddress(ctx, addr))
	}

	username := types.Username{Value: msg.Username}
	accountAddr := types.AccountAddr{Value: msg.Creator}

	found := k.HasUsername(ctx, username) || k.HasAccountAddr(ctx, accountAddr)
	if found {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "username already taken")
	}

	k.SetPylonsAccount(ctx, accountAddr, username)

	err = ctx.EventManager().EmitTypedEvent(&types.EventCreateAccount{
		Address:  msg.Creator,
		Username: msg.Username,
	})

	return &types.MsgCreateAccountResponse{}, err
}

func (k msgServer) UpdateAccount(goCtx context.Context, msg *types.MsgUpdateAccount) (*types.MsgUpdateAccountResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	addr, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "unable to derive address from bech32 string")
	}
	acc := k.accountKeeper.GetAccount(ctx, addr)
	if acc == nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "account not created")
	}

	username := types.Username{Value: msg.Username}
	accountAddr := types.AccountAddr{Value: msg.Creator}

	found := k.HasUsername(ctx, username)
	if found {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "username already taken")
	}

	// TODO fee for updating account

	k.SetPylonsAccount(ctx, accountAddr, username)

	err = ctx.EventManager().EmitTypedEvent(&types.EventUpdateAccount{
		Address:  msg.Creator,
		Username: msg.Username,
	})

	return &types.MsgUpdateAccountResponse{}, err
}
