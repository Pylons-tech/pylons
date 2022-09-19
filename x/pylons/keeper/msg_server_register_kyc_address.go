package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (k msgServer) RegisterKYCAddress(goCtx context.Context, msg *types.MsgRegisterKYCAddress) (*types.MsgRegisterKYCAddressResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)

	addr, err := sdk.AccAddressFromBech32(msg.AccountAddr)
	if err != nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "unable to derive address from bech32 string")
	}

	acc := k.accountKeeper.GetAccount(ctx, addr)
	if acc == nil {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "account not created")
	}

	kycAcc := types.KYCAccount{
		AccountAddr: msg.AccountAddr,
		Username:    msg.Username,
		Level:       msg.Level,
		Provider:    msg.Provider,
		ProviderId:  msg.ProviderId,
	}

	_, found := k.GetPylonsKYC(ctx, kycAcc.AccountAddr)
	if found == true {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, "kyc account has been registered")
	}

	if k.HasAccountAddr(ctx, types.AccountAddr{Value: msg.AccountAddr}) {
		k.SetPylonsKYC(ctx, kycAcc)
	} else {
		return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "kyc account address not found")
	}

	err = ctx.EventManager().EmitTypedEvent(&types.EventRegisterKYCAccount{
		Address:    msg.AccountAddr,
		Username:   msg.Username,
		Level:      msg.Level,
		Provider:   msg.Provider,
		ProviderId: msg.ProviderId,
	})

	return &types.MsgRegisterKYCAddressResponse{}, err
}
