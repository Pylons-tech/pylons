package v4

import (
	pylonskeeper "github.com/Pylons-tech/pylons/x/pylons/keeper"
	pylonstypes "github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	authsigning "github.com/cosmos/cosmos-sdk/x/auth/signing"
	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"
)

type MsgRestrictUbedrockDecorator struct {
	pk pylonskeeper.Keeper
}

func NewMsgRestrictUbedrockDecorator(pk pylonskeeper.Keeper) MsgRestrictUbedrockDecorator {
	return MsgRestrictUbedrockDecorator{
		pk: pk,
	}
}

// AnteDecorator for restrict ubedrock denom used by unallowed address
func (ad MsgRestrictUbedrockDecorator) AnteHandle(ctx sdk.Context, tx sdk.Tx, simulate bool, next sdk.AnteHandler) (sdk.Context, error) {
	if (ctx.IsCheckTx() || ctx.IsReCheckTx()) && !simulate {
		sigTx, ok := tx.(authsigning.SigVerifiableTx)
		if !ok {
			return ctx, sdkerrors.Wrap(sdkerrors.ErrTxDecode, "invalid transaction type")
		}

		messages := sigTx.GetMsgs()
		if len(messages) <= 0 {
			return ctx, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "invalid messages")
		}
		for _, message := range messages {
			msgSend, ok := message.(*banktypes.MsgSend)
			if !ok {
				continue
			}

			ok, _ = msgSend.Amount.Find(pylonstypes.StakingCoinDenom)
			if !ok {
				continue
			}

			if _, kycAcc_found := ad.pk.GetPylonsKYC(ctx, msgSend.ToAddress); !kycAcc_found {
				return ctx, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "'ubedrock' should only be transferred among allowed address")
			}
		}
	}
	return next(ctx, tx, simulate)
}
