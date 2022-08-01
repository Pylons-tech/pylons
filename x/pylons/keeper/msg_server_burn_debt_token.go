package keeper

import (
	"context"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	sdk "github.com/cosmos/cosmos-sdk/types"
)

func (k msgServer) BurnDebtToken(goCtx context.Context, msg *v1beta1.MsgBurnDebtToken) (*v1beta1.MsgBurnDebtTokenResponse, error) {
	ctx := sdk.UnwrapSDKContext(goCtx)
	paymentProcessors := k.PaymentProcessors(ctx)

	found := false
	for _, pp := range paymentProcessors {
		if msg.RedeemInfo.ProcessorName == pp.Name {
			found = true
			err := pp.ValidateRedeemInfo(msg.RedeemInfo)
			if err != nil {
				return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			coins := sdk.NewCoins(sdk.NewCoin(pp.CoinDenom, msg.RedeemInfo.Amount))
			addr, _ := sdk.AccAddressFromBech32(msg.RedeemInfo.Address)
			err = k.BurnCreditFromAddr(ctx, addr, coins)
			if err != nil {
				return nil, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}
			break
		}
	}
	if !found {
		return nil, sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "could not find %s among valid payment processors", msg.RedeemInfo.ProcessorName)
	}

	k.SetRedeemInfo(ctx, msg.RedeemInfo)

	err := ctx.EventManager().EmitTypedEvent(&v1beta1.EventBurnDebtToken{
		RedeemInfo: msg.RedeemInfo,
	})

	return &v1beta1.MsgBurnDebtTokenResponse{}, err
}
