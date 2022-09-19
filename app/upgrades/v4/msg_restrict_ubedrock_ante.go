package v4

import (
	pylonstypes "github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	authsigning "github.com/cosmos/cosmos-sdk/x/auth/signing"
	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"
)

// FeegrantKeeper defines the expected feegrant keeper.
type PylonsKeeper interface {
	GetParams(ctx sdk.Context) (params pylonstypes.Params)
	GetPylonsKYC(ctx sdk.Context, kycaddr string) (val pylonstypes.KYCAccount, found bool)
}

type MsgRestrictUbedrockDecorator struct {
	pk PylonsKeeper
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
