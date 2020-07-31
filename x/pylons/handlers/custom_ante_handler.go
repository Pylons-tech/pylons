package handlers

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/cosmos/cosmos-sdk/x/auth"
	"github.com/cosmos/cosmos-sdk/x/auth/ante"
	"github.com/cosmos/cosmos-sdk/x/auth/exported"
	"github.com/cosmos/cosmos-sdk/x/auth/keeper"
	"github.com/cosmos/cosmos-sdk/x/auth/types"
)

// NewAnteHandler returns an AnteHandler that checks and increments sequence
// numbers, checks signatures & account numbers, and deducts fees from the first
// signer.
func NewAnteHandler(ak keeper.AccountKeeper, supplyKeeper types.SupplyKeeper, sigGasConsumer ante.SignatureVerificationGasConsumer) sdk.AnteHandler {
	return sdk.ChainAnteDecorators(
		ante.NewSetUpContextDecorator(), // outermost AnteDecorator. SetUpContext must be called first
		// ante.NewMempoolFeeDecorator(),
		ante.NewValidateBasicDecorator(),
		ante.NewValidateMemoDecorator(ak),
		// ante.NewConsumeGasForTxSizeDecorator(ak),
		// we create the account locally before there is any access for it
		NewAccountCreationDecorator(ak),
		ante.NewSetPubKeyDecorator(ak), // SetPubKeyDecorator must be called before all signature verification decorators
		ante.NewValidateSigCountDecorator(ak),
		// ante.NewDeductFeeDecorator(ak, supplyKeeper),
		// ante.NewSigGasConsumeDecorator(ak, sigGasConsumer),
		NewCustomSigVerificationDecorator(ak),
		ante.NewIncrementSequenceDecorator(ak), // innermost AnteDecorator
	)
}

// AccountCreationDecorator create an account if it does not exist
type AccountCreationDecorator struct {
	ak keeper.AccountKeeper
}

// NewAccountCreationDecorator create account if account does not exist already
func NewAccountCreationDecorator(ak keeper.AccountKeeper) AccountCreationDecorator {
	return AccountCreationDecorator{
		ak: ak,
	}
}

// AnteHandle is a handler for NewAccountCreationDecorator
func (svd AccountCreationDecorator) AnteHandle(ctx sdk.Context, tx sdk.Tx, simulate bool, next sdk.AnteHandler) (newCtx sdk.Context, err error) {
	sigTx, ok := tx.(types.StdTx)
	if !ok {
		return ctx, sdkerrors.Wrap(sdkerrors.ErrTxDecode, "invalid transaction type")
	}
	messages := sigTx.GetMsgs()

	if len(messages) == 1 && messages[0].Type() == "create_account" && sigTx.Signatures != nil && len(sigTx.Signatures) > 0 {
		fmt.Println("Running NewAccountCreationDecorator...")
		// we don't support multi-message transaction for create_account
		pubkey := sigTx.Signatures[0].PubKey
		address := sdk.AccAddress(pubkey.Address().Bytes())
		msgCreateAccount, ok := messages[0].(msgs.MsgCreateAccount)
		if !ok {
			return ctx, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "error msg conversion to MsgCreateAccount")
		}

		if address.String() != msgCreateAccount.Requester.String() {
			return ctx, sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, "mismatch between signature pubkey and requester address")
		}

		fmt.Println(address.String() + " received")
		// if the account doesnt exist we set it
		if svd.ak.GetAccount(ctx, address) == nil {
			fmt.Println("Creating new account")
			acc := &auth.BaseAccount{
				Sequence:      0,
				Coins:         sdk.Coins{},
				AccountNumber: svd.ak.GetNextAccountNumber(ctx),
				PubKey:        pubkey,
				Address:       address,
			}
			svd.ak.SetAccount(ctx, acc)
		} else {
			return ctx, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "account already exist")
		}
	}
	return next(ctx, tx, simulate)
}

// CustomSigVerificationDecorator is a custom verification decorator designed for create_account
type CustomSigVerificationDecorator struct {
	ak keeper.AccountKeeper
}

// NewCustomSigVerificationDecorator automatically sign transaction if it's create-account msg
func NewCustomSigVerificationDecorator(ak keeper.AccountKeeper) CustomSigVerificationDecorator {
	return CustomSigVerificationDecorator{
		ak: ak,
	}
}

// AnteHandle is a handler for CustomSigVerificationDecorator
func (svd CustomSigVerificationDecorator) AnteHandle(ctx sdk.Context, tx sdk.Tx, simulate bool, next sdk.AnteHandler) (newCtx sdk.Context, err error) {
	// no need to verify signatures on recheck tx
	if ctx.IsReCheckTx() {
		return next(ctx, tx, simulate)
	}
	sigTx, ok := tx.(ante.SigVerifiableTx)
	if !ok {
		return ctx, sdkerrors.Wrap(sdkerrors.ErrTxDecode, "invalid transaction type")
	}

	// stdSigs contains the sequence number, account number, and signatures.
	// When simulating, this would just be a 0-length slice.
	sigs := sigTx.GetSignatures()

	// stdSigs contains the sequence number, account number, and signatures.
	// When simulating, this would just be a 0-length slice.
	signerAddrs := sigTx.GetSigners()
	signerAccs := make([]exported.Account, len(signerAddrs))

	// check that signer length and signature length are the same
	if len(sigs) != len(signerAddrs) {
		return ctx, sdkerrors.Wrapf(sdkerrors.ErrUnauthorized, "invalid number of signer;  expected: %d, got %d", len(signerAddrs), len(sigs))
	}

	for i, sig := range sigs {

		signerAccs[i], err = ante.GetSignerAcc(ctx, svd.ak, signerAddrs[i])
		if err != nil {
			return ctx, err
		}

		// retrieve signBytes of tx

		signBytes := sigTx.GetSignBytes(ctx, signerAccs[i])

		// retrieve pubkey
		pubKey := signerAccs[i].GetPubKey()
		if !simulate && pubKey == nil {
			return ctx, sdkerrors.Wrap(sdkerrors.ErrInvalidPubKey, "pubkey on account is not set")
		}

		messages := sigTx.GetMsgs()
		if len(messages) == 1 && messages[0].Type() == "create_account" {
			acc := &auth.BaseAccount{
				Sequence:      0,
				Coins:         sdk.Coins{},
				AccountNumber: 0, // we do check account number 0 for create_account message
				PubKey:        pubKey,
				Address:       pubKey.Address().Bytes(),
			}
			signBytes := sigTx.GetSignBytes(ctx, acc)
			if !simulate && !pubKey.VerifyBytes(signBytes, sig) {
				return ctx, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "create_account signature verification failed; verify correct account sequence and chain-id")
			}
			continue
		}

		// verify signature
		if !simulate && !pubKey.VerifyBytes(signBytes, sig) {
			return ctx, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "signature verification failed; verify correct account sequence and chain-id")
		}
	}

	return next(ctx, tx, simulate)
}
