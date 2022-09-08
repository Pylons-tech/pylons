package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/telemetry"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (k msgServer) RegisterKYCAddress(goCtx context.Context, msg *types.MsgRegisterKYCAddress) (*types.MsgRegisterKYCAddressResponse, error) {
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
	kycAddr := types.KYCAddress{Value: msg.Creator}

	_, found := k.GetPylonsKYC(ctx, kycAddr.Value)

	if found == true {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, "kyc account has been registered")
	}

	k.SetPylonsKYC(ctx, kycAddr, username)

	err = ctx.EventManager().EmitTypedEvent(&types.EventRegisterKYCAccount{
		Address:  msg.Creator,
		Username: msg.Username,
	})

	telemetry.IncrCounter(1, "kycaddress", "register")

	return &types.MsgRegisterKYCAddressResponse{}, err
}
