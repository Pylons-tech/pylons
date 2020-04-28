package handlers

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/cosmos/cosmos-sdk/x/auth"
	"github.com/cosmos/cosmos-sdk/x/auth/ante"
	"github.com/cosmos/cosmos-sdk/x/auth/keeper"
	"github.com/cosmos/cosmos-sdk/x/auth/types"
)

// NewAnteHandler returns an AnteHandler that checks and increments sequence
// numbers, checks signatures & account numbers, and deducts fees from the first
// signer.
func NewAnteHandler(ak keeper.AccountKeeper, supplyKeeper types.SupplyKeeper, sigGasConsumer ante.SignatureVerificationGasConsumer) sdk.AnteHandler {
	return sdk.ChainAnteDecorators(
		ante.NewSetUpContextDecorator(), // outermost AnteDecorator. SetUpContext must be called first
		ante.NewMempoolFeeDecorator(),
		ante.NewValidateBasicDecorator(),
		ante.NewValidateMemoDecorator(ak),
		ante.NewConsumeGasForTxSizeDecorator(ak),
		// we create the account locally before there is any access for it
		NewAccountCreationDecorator(ak),
		ante.NewSetPubKeyDecorator(ak), // SetPubKeyDecorator must be called before all signature verification decorators
		ante.NewValidateSigCountDecorator(ak),
		ante.NewDeductFeeDecorator(ak, supplyKeeper),
		ante.NewSigGasConsumeDecorator(ak, sigGasConsumer),
		ante.NewSigVerificationDecorator(ak),
		ante.NewIncrementSequenceDecorator(ak), // innermost AnteDecorator
	)
}

// AccountCreationDecorator by passes the signature verification
type AccountCreationDecorator struct {
	ak keeper.AccountKeeper
}

func NewAccountCreationDecorator(ak keeper.AccountKeeper) AccountCreationDecorator {
	return AccountCreationDecorator{
		ak: ak,
	}
}

func (svd AccountCreationDecorator) AnteHandle(ctx sdk.Context, tx sdk.Tx, simulate bool, next sdk.AnteHandler) (newCtx sdk.Context, err error) {
	// no need to verify signatures on recheck tx
	if ctx.IsReCheckTx() {
		return next(ctx, tx, simulate)
	}
	sigTx, ok := tx.(types.StdTx)
	if !ok {
		return ctx, sdkerrors.Wrap(sdkerrors.ErrTxDecode, "invalid transaction type")
	}
	messages := sigTx.GetMsgs()
	if len(messages) > 0 && messages[0].Type() == "get_pylons" {
		pubkey := sigTx.Signatures[0].PubKey
		address := sdk.AccAddress(pubkey.Address().Bytes())

		fmt.Println(address.String() + " received")
		// if the account doesnt exist we set it
		if svd.ak.GetAccount(ctx, address) == nil {
			fmt.Println("Account not found")
			acc := &auth.BaseAccount{
				Sequence:      0,
				Coins:         sdk.Coins{},
				AccountNumber: svd.ak.GetNextAccountNumber(ctx),
				PubKey:        pubkey,
				Address:       address,
			}
			svd.ak.SetAccount(ctx, acc)
		}

	}
	return next(ctx, tx, simulate)
}
