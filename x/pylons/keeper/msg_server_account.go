package keeper

import (
	"context"

	"github.com/cosmos/cosmos-sdk/telemetry"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k msgServer) CreateAccount(goCtx context.Context, msg *types.MsgCreateAccount) (*types.MsgCreateAccountResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	err := k.verifyAppCheck(msg)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	addr, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "unable to derive address from bech32 string")
	}
	acc := k.accountKeeper.GetAccount(ctx, addr)
	if acc == nil {
		k.accountKeeper.NewAccountWithAddress(ctx, addr)
		defer telemetry.IncrCounter(1, "new", "account")
	}

	username := types.Username{Value: ""}
	accountAddr := types.AccountAddr{Value: msg.Creator}

	found := k.HasUsername(ctx, username) || k.HasAccountAddr(ctx, accountAddr)
	if found {
		return nil, types.ErrDuplicateUsername
	}

	if len(msg.ReferralAddress) > 0 {
		referralAddr := types.AccountAddr{Value: msg.ReferralAddress}
		if k.HasAccountAddr(ctx, referralAddr) {
			k.SetPylonsReferral(ctx, msg.Creator, "", msg.ReferralAddress)
		} else {
			return nil, types.ErrReferralUserNotFound
		}
	}

	k.SetPylonsAccount(ctx, accountAddr, username)

	err = ctx.EventManager().EmitTypedEvent(&types.EventCreateAccount{
		Address: msg.Creator,
	})

	telemetry.IncrCounter(1, "account", "create")

	return &types.MsgCreateAccountResponse{}, err
}

func (k msgServer) SetUsername(goCtx context.Context, msg *types.MsgSetUsername) (*types.MsgSetUsernameResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	addr, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "unable to derive address from bech32 string")
	}
	acc := k.accountKeeper.GetAccount(ctx, addr)
	if acc == nil {
		return nil, types.ErrAccountNotFound
	}

	username := types.Username{Value: msg.Username}
	accountAddr := types.AccountAddr{Value: msg.Creator}

	found := k.HasAccountAddr(ctx, accountAddr)
	if !found {
		return nil, types.ErrAccountNotFound
	}
	found = k.HasUsername(ctx, username)
	if found {
		return nil, types.ErrDuplicateUsername
	}

	k.UpdatePylonsAccount(ctx, accountAddr, username)

	telemetry.IncrCounter(1, "account", "setsername")

	return &types.MsgSetUsernameResponse{}, err
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
		return nil, types.ErrDuplicateUsername
	}

	k.UpdatePylonsAccount(ctx, accountAddr, username)

	// perform payment after update
	updateFee := k.Keeper.UpdateUsernameFee(ctx)
	err = k.PayFees(ctx, addr, sdk.NewCoins(updateFee))
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	err = ctx.EventManager().EmitTypedEvent(&types.EventUpdateAccount{
		Address:  msg.Creator,
		Username: msg.Username,
	})

	telemetry.IncrCounter(1, "account", "update")

	return &types.MsgUpdateAccountResponse{}, err
}

func (k msgServer) verifyAppCheck(msg *types.MsgCreateAccount) error {
	if types.DefaultNoAppCheckConfig {
		return nil
	}
	err := types.VerifyAppCheckToken(msg.Token)
	if err != nil {
		return status.Errorf(codes.Unauthenticated, "unable to verify app-check token %v", err)
	}
	return nil
}
