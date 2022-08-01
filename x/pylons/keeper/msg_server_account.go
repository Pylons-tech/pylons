package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	"github.com/cosmos/cosmos-sdk/telemetry"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func (k msgServer) CreateAccount(goCtx context.Context, msg *v1beta1.MsgCreateAccount) (*v1beta1.MsgCreateAccountResponse, error) {
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

	username := v1beta1.Username{Value: msg.Username}
	accountAddr := v1beta1.AccountAddr{Value: msg.Creator}

	found := k.HasUsername(ctx, username) || k.HasAccountAddr(ctx, accountAddr)
	if found {
		return nil, v1beta1.ErrDuplicateUsername
	}

	k.SetPylonsAccount(ctx, accountAddr, username)
	if len(msg.ReferralAddress) > 0 {
		referralAddr := v1beta1.AccountAddr{Value: msg.ReferralAddress}
		if k.HasAccountAddr(ctx, referralAddr) {
			k.SetPylonsReferral(ctx, msg.Creator, msg.Username, msg.ReferralAddress)
		} else {
			return nil, v1beta1.ErrReferralUserNotFound
		}
	}

	err = ctx.EventManager().EmitTypedEvent(&v1beta1.EventCreateAccount{
		Address:  msg.Creator,
		Username: msg.Username,
	})

	telemetry.IncrCounter(1, "account", "create")

	return &v1beta1.MsgCreateAccountResponse{}, err
}

func (k msgServer) UpdateAccount(goCtx context.Context, msg *v1beta1.MsgUpdateAccount) (*v1beta1.MsgUpdateAccountResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	addr, err := sdk.AccAddressFromBech32(msg.Creator)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "unable to derive address from bech32 string")
	}
	acc := k.accountKeeper.GetAccount(ctx, addr)
	if acc == nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "account not created")
	}

	username := v1beta1.Username{Value: msg.Username}
	accountAddr := v1beta1.AccountAddr{Value: msg.Creator}

	found := k.HasUsername(ctx, username)
	if found {
		return nil, v1beta1.ErrDuplicateUsername
	}

	k.SetPylonsAccount(ctx, accountAddr, username)

	// perform payment after update
	updateFee := k.Keeper.UpdateUsernameFee(ctx)
	err = k.PayFees(ctx, addr, sdk.NewCoins(updateFee))
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
	}

	err = ctx.EventManager().EmitTypedEvent(&v1beta1.EventUpdateAccount{
		Address:  msg.Creator,
		Username: msg.Username,
	})

	telemetry.IncrCounter(1, "account", "update")

	return &v1beta1.MsgUpdateAccountResponse{}, err
}

func (k msgServer) verifyAppCheck(msg *v1beta1.MsgCreateAccount) error {
	if v1beta1.DefaultNoAppCheckConfig {
		return nil
	}
	err := v1beta1.VerifyAppCheckToken(msg.Token)
	if err != nil {
		return status.Errorf(codes.Unauthenticated, "unable to verify app-check token %v", err)
	}
	return nil
}
