package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
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

	kycAcc := types.KYCAccount{
		AccountAddr: msg.Creator,
		Username:    msg.Username,
	}

	_, found := k.GetPylonsKYC(ctx, kycAcc.AccountAddr)
	if found == true {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, "kyc account has been registered")
	}

	if k.HasAccountAddr(ctx, types.AccountAddr{Value: msg.Creator}) {
		k.SetPylonsKYC(ctx, kycAcc)
	} else {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "kyc account address not found")
	}

	err = ctx.EventManager().EmitTypedEvent(&types.EventRegisterKYCAccount{
		Address:  msg.Creator,
		Username: msg.Username,
	})

	return &types.MsgRegisterKYCAddressResponse{}, err
}
