package app

import (
	"fmt"

	codectypes "github.com/cosmos/cosmos-sdk/codec/types"
	"github.com/cosmos/cosmos-sdk/telemetry"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/cosmos/cosmos-sdk/types/tx/signing"
	"github.com/cosmos/cosmos-sdk/x/auth/ante"
	authsigning "github.com/cosmos/cosmos-sdk/x/auth/signing"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// NewAnteHandler returns an AnteHandler that checks and increments sequence
// numbers, checks signatures & account numbers, and doesn't deduct fees.
func NewAnteHandler(
	ak types.AccountKeeper,
	// bankKeeper types.BankKeeper,
	// sigGasConsumer authsigning.SignatureVerificationGasConsumer,
	signModeHandler authsigning.SignModeHandler,
) sdk.AnteHandler {
	return sdk.ChainAnteDecorators(
		ante.NewSetUpContextDecorator(), // outermost AnteDecorator. SetUpContext must be called first
		//		ante.NewExtensionOptionsDecorator(),
		// ante.NewMempoolFeeDecorator(),
		ante.NewValidateBasicDecorator(),
		ante.TxTimeoutHeightDecorator{},
		ante.NewValidateMemoDecorator(ak),
		// ante.NewConsumeGasForTxSizeDecorator(ak),
		// ante.NewRejectFeeGranterDecorator(),
		// we create the account locally before there is any access for it
		NewAccountCreationDecorator(ak),
		ante.NewSetPubKeyDecorator(ak), // SetPubKeyDecorator must be called before all signature verification decorators
		ante.NewValidateSigCountDecorator(ak),
		// ante.NewDeductFeeDecorator(ak, bankKeeper),
		// ante.NewSigGasConsumeDecorator(ak, sigGasConsumer),
		// ante.NewSigVerificationDecorator(ak, signModeHandler),
		NewCustomSigVerificationDecorator(ak, signModeHandler),
		ante.NewIncrementSequenceDecorator(ak),
	)
}

// AccountCreationDecorator create an account if it does not exist
type AccountCreationDecorator struct {
	ak types.AccountKeeper
}

// NewAccountCreationDecorator create account if account does not exist already
func NewAccountCreationDecorator(ak types.AccountKeeper) AccountCreationDecorator {
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

	msgCreateAccount, ok := messages[0].(*types.MsgCreateAccount)
	if len(messages) == 1 && sigTxSignatures != nil && len(sigTxSignatures) > 0 && ok {
		// we don't support multi-message transaction for create_account
		pubkey := sigTxSignatures[0].PubKey
		address := sdk.AccAddress(pubkey.Address().Bytes())

		if address.String() != msgCreateAccount.Creator {
			return ctx, sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, "mismatch between signature pubkey and requester address")
		}

		// if the account doesn't exist we set it
		getAcc := svd.ak.GetAccount(ctx, address)
		if getAcc == nil {
			any, err := codectypes.NewAnyWithValue(pubkey)
			if err != nil {
				return ctx, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			acc := &authtypes.BaseAccount{
				Sequence:      0,
				AccountNumber: svd.ak.GetNextAccountNumber(ctx),
				PubKey:        any,
				Address:       address.String(),
			}
			svd.ak.SetAccount(ctx, acc)
			defer telemetry.IncrCounter(1, "new", "account")
		} else {
			return ctx, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "account already exists")
		}
	}
	return next(ctx, tx, simulate)
}

// CustomSigVerificationDecorator is a custom verification decorator designed for create_account
type CustomSigVerificationDecorator struct {
	ak              types.AccountKeeper
	signModeHandler authsigning.SignModeHandler
}

// NewCustomSigVerificationDecorator automatically sign transaction if it's create-account msg
func NewCustomSigVerificationDecorator(ak types.AccountKeeper, signModeHandler authsigning.SignModeHandler) CustomSigVerificationDecorator {
	return CustomSigVerificationDecorator{
		ak:              ak,
		signModeHandler: signModeHandler,
	}
}

// OnlyLegacyAminoSigners checks SignatureData to see if all
// signers are using SIGN_MODE_LEGACY_AMINO_JSON. If this is the case
// then the corresponding SignatureV2 struct will not have account sequence
// explicitly set, and we should skip the explicit verification of sig.Sequence
// in the SigVerificationDecorator's AnteHandler function.
func OnlyLegacyAminoSigners(sigData signing.SignatureData) bool {
	switch v := sigData.(type) {
	case *signing.SingleSignatureData:
		return v.SignMode == signing.SignMode_SIGN_MODE_LEGACY_AMINO_JSON
	case *signing.MultiSignatureData:
		for _, s := range v.Signatures {
			if !OnlyLegacyAminoSigners(s) {
				return false
			}
		}
		return true
	default:
		return false
	}
}

func GetSignerAcc(ctx sdk.Context, ak types.AccountKeeper, addr sdk.AccAddress) (authtypes.AccountI, error) {
	if acc := ak.GetAccount(ctx, addr); acc != nil {
		return acc, nil
	}

	return nil, sdkerrors.Wrapf(sdkerrors.ErrUnknownAddress, "account %s does not exist", addr)
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
	sigs, err := sigTx.GetSignaturesV2()
	if err != nil {
		return ctx, err
	}

	signerAddrs := sigTx.GetSigners()

	// check that signer length and signature length are the same
	if len(sigs) != len(signerAddrs) {
		return ctx, sdkerrors.Wrapf(sdkerrors.ErrUnauthorized, "invalid number of signer;  expected: %d, got %d", len(signerAddrs), len(sigs))
	}

	for i, sig := range sigs {
		acc, err := GetSignerAcc(ctx, svd.ak, signerAddrs[i])
		if err != nil {
			return ctx, err
		}

		// retrieve pubkey
		pubKey := acc.GetPubKey()
		if !simulate && pubKey == nil {
			return ctx, sdkerrors.Wrap(sdkerrors.ErrInvalidPubKey, "pubkey on account is not set")
		}

		// Check account sequence number.
		if sig.Sequence != acc.GetSequence() {
			return ctx, sdkerrors.Wrapf(
				sdkerrors.ErrWrongSequence,
				"account sequence mismatch, expected %d, got %d", acc.GetSequence(), sig.Sequence,
			)
		}

		genesis := ctx.BlockHeight() == 0
		chainID := ctx.ChainID()
		var accNum uint64
		if !genesis {
			accNum = acc.GetAccountNumber()
		}
		signerData := authsigning.SignerData{
			ChainID:       chainID,
			AccountNumber: accNum,
			Sequence:      acc.GetSequence(),
		}

		messages := sigTx.GetMsgs()
		_, ok := messages[0].(*types.MsgCreateAccount)
		if len(messages) == 1 && ok {
			_, err := codectypes.NewAnyWithValue(pubKey)
			if err != nil {
				return ctx, sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
			}

			// MsgCreateAccount is creating account dynamically and account number and sequence are not registered.
			// But we need to verify pubkey and do signature verification for accountNumber=0,sequence=0 message
			signerData.AccountNumber = 0
			signerData.Sequence = 0

			err = authsigning.VerifySignature(pubKey, signerData, sig.Data, svd.signModeHandler, tx)
			if !simulate && err != nil {
				return ctx, sdkerrors.Wrapf(sdkerrors.ErrUnauthorized, "create_account signature verification failed; verify correct account sequence and chain-id: %s", err.Error())
			}
			continue
		}

		// verify signature
		if !simulate {
			err := authsigning.VerifySignature(pubKey, signerData, sig.Data, svd.signModeHandler, tx)
			if err != nil {
				var errMsg string
				if OnlyLegacyAminoSigners(sig.Data) {
					// If all signers are using SIGN_MODE_LEGACY_AMINO, we rely on VerifySignature to check account sequence number,
					// and therefore communicate sequence number as a potential cause of error.
					errMsg = fmt.Sprintf("signature verification failed; please verify account number (%d), sequence (%d) and chain-id (%s)", accNum, acc.GetSequence(), chainID)
				} else {
					errMsg = fmt.Sprintf("signature verification failed; please verify account number (%d) and chain-id (%s)", accNum, chainID)
				}
				return ctx, sdkerrors.Wrap(sdkerrors.ErrUnauthorized, errMsg)
			}
		}
	}

	return next(ctx, tx, simulate)
}
