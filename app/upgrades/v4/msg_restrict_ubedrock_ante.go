package v4

import (
	pylonskeeper "github.com/Pylons-tech/pylons/x/pylons/keeper"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	authsigning "github.com/cosmos/cosmos-sdk/x/auth/signing"
	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"
)

type MsgRestrictUbedrockDecorator struct {
	pk pylonskeeper.Keeper
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

		if msgSend, ok := messages[0].(*banktypes.MsgSend); ok {
			if ok, _ = msgSend.Amount.Find("ubedrock"); ok {
				if _, kycAcc_found := ad.pk.GetPylonsKYC(ctx, msgSend.ToAddress); kycAcc_found == false {
					panic("'ubedrock' should only be transfer among allowed address")
				}
			}
		}
	}
	return next(ctx, tx, simulate)
}
