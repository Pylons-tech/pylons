package handlers

import (
	"fmt"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	codectypes "github.com/cosmos/cosmos-sdk/codec/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/cosmos/cosmos-sdk/x/auth/ante"
	"github.com/cosmos/cosmos-sdk/x/auth/keeper"
	authsigning "github.com/cosmos/cosmos-sdk/x/auth/signing"
	"github.com/cosmos/cosmos-sdk/x/auth/types"
)

// NewAnteHandler returns an AnteHandler that checks and increments sequence
// numbers, checks signatures & account numbers, and deducts fees from the first
// signer.
func NewAnteHandler(ak keeper.AccountKeeper) sdk.AnteHandler {
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
	sigTx, ok := tx.(authsigning.SigVerifiableTx)
	if !ok {
		return ctx, sdkerrors.Wrap(sdkerrors.ErrTxDecode, "invalid transaction type")
	}
	messages := sigTx.GetMsgs()

	sigTxSignatures, err := sigTx.GetSignaturesV2()
	if err != nil {
		return ctx, sdkerrors.Wrap(err, "getting signatures of tx is failed")
	}

	if len(messages) == 1 && messages[0].Type() == "create_account" && sigTxSignatures != nil && len(sigTxSignatures) > 0 {
		// we don't support multi-message transaction for create_account
		pubkey := sigTxSignatures[0].PubKey
		address := sdk.AccAddress(pubkey.Address().Bytes())
		fmt.Println(sigTx.GetPubKeys()[0].Address().String())
		msgCreateAccount, ok := messages[0].(*msgs.MsgCreateAccount)
		if !ok {
			return ctx, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "error msg conversion to MsgCreateAccount")
		}

		if address.String() != msgCreateAccount.Requester {
			return ctx, sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, "mismatch between signature pubkey and requester address")
		}

		// if the account doesnt exist we set it
		if svd.ak.GetAccount(ctx, address) == nil {
			any, err := codectypes.NewAnyWithValue(pubkey)
			if err != nil {
				return ctx, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			acc := &types.BaseAccount{
				Sequence:      0,
				AccountNumber: svd.ak.GetNextAccountNumber(ctx),
				PubKey:        any,
				Address:       address.String(),
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
	sigTx, ok := tx.(authsigning.SigVerifiableTx)
	if !ok {
		return ctx, sdkerrors.Wrap(sdkerrors.ErrTxDecode, "invalid transaction type")
	}

	// stdSigs contains the sequence number, account number, and signatures.
	// When simulating, this would just be a 0-length slice.
	sigs, _ := sigTx.GetSignaturesV2()

	// stdSigs contains the sequence number, account number, and signatures.
	// When simulating, this would just be a 0-length slice.
	signerAddrs := sigTx.GetSigners()
	signerAccs := make([]types.AccountI, len(signerAddrs))

	// check that signer length and signature length are the same
	if len(sigs) != len(signerAddrs) {
		return ctx, sdkerrors.Wrapf(sdkerrors.ErrUnauthorized, "invalid number of signer;  expected: %d, got %d", len(signerAddrs), len(sigs))
	}

	for i, sig := range sigs {

		signerAccs[i], err = ante.GetSignerAcc(ctx, svd.ak, signerAddrs[i])
		if err != nil {
			return ctx, err
		}

		// Check account sequence number.
		// When using Amino StdSignatures, we actually don't have the Sequence in
		// the SignatureV2 struct (it's only in the SignDoc). In this case, we
		// cannot check sequence directly, and must do it via signature
		// verification (in the VerifySignature call below).
		onlyAminoSigners := ante.OnlyLegacyAminoSigners(sig.Data)
		if !onlyAminoSigners {
			if sig.Sequence != signerAccs[i].GetSequence() {
				return ctx, sdkerrors.Wrapf(
					sdkerrors.ErrWrongSequence,
					"account sequence mismatch, expected %d, got %d", signerAccs[i].GetSequence(), sig.Sequence,
				)
			}
		}

		// retrieve pubkey
		pubKey := signerAccs[i].GetPubKey()
		if !simulate && pubKey == nil {
			return ctx, sdkerrors.Wrap(sdkerrors.ErrInvalidPubKey, "pubkey on account is not set")
		}

		messages := sigTx.GetMsgs()
		if len(messages) == 1 && messages[0].Type() == "create_account" {
			any, err := codectypes.NewAnyWithValue(pubKey)
			if err != nil {
				return ctx, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			_ = &types.BaseAccount{
				Sequence:      0,
				AccountNumber: 0, // we do check account number 0 for create_account message
				PubKey:        any,
				Address:       pubKey.Address().String(),
			}
			onlyAminoSigners := ante.OnlyLegacyAminoSigners(sig.Data)
			if !onlyAminoSigners {
				if sig.Sequence != signerAccs[i].GetSequence() {
					return ctx, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "create_account signature verification failed; verify correct account sequence and chain-id")
				}
			}
			//signBytes := sigTx.GetSignBytes(ctx, acc)
			//if !simulate && !pubKey.VerifySignature(signBytes, sig) {
			//	return ctx, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "create_account signature verification failed; verify correct account sequence and chain-id")
			//}
			continue
		}

		// verify signature
		//if !simulate && !pubKey.VerifyBytes(signBytes, sig) {
		//	return ctx, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, "signature verification failed; verify correct account sequence and chain-id")
		//}
	}

	return next(ctx, tx, simulate)
}
