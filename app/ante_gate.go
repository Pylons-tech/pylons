package app

import (
	"fmt"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	authsigning "github.com/cosmos/cosmos-sdk/x/auth/signing"
)

type AnteSpamMigitationDecorator struct {
	pk PylonsKeeper
}

type AnteRestrictUbedrockDecorator struct {
	pk PylonsKeeper
}

func NewSpamMigitationAnteDecorator(pylonsmodulekeeper PylonsKeeper) AnteSpamMigitationDecorator {
	return AnteSpamMigitationDecorator{
		pk: pylonsmodulekeeper,
	}
}

func NewRestrictUbedrockAnteDecorator(pylonsmodulekeeper PylonsKeeper) AnteRestrictUbedrockDecorator {
	return AnteRestrictUbedrockDecorator{
		pk: pylonsmodulekeeper,
	}
}

// AnteDecorator
func (ad AnteSpamMigitationDecorator) AnteHandle(ctx sdk.Context, tx sdk.Tx, simulate bool, next sdk.AnteHandler) (sdk.Context, error) {
	fmt.Printf("[LOG] AnteSpamMigitationDecorator - AnteHandle - LINE 23\n")
	if (ctx.IsCheckTx() || ctx.IsReCheckTx()) && !simulate {
		fmt.Printf("[LOG] AnteSpamMigitationDecorator - AnteHandle - LINE 25\n")
		sigTx, ok := tx.(authsigning.SigVerifiableTx)
		if !ok {
			return ctx, sdkerrors.Wrap(sdkerrors.ErrTxDecode, "invalid transaction type")
		}
		// ad.pk.GetParams(ctx)
		// get max txs in a block, default is 20
		params := ad.pk.GetParams(ctx)
		maxTxs := params.MaxTxsInBlock

		// increment sequence of all signers
		for _, addr := range sigTx.GetSigners() {
			AccountTrack[addr.String()]++
			if AccountTrack[addr.String()] > maxTxs {
				panic(fmt.Sprintf("maximum txs in block is %d ", maxTxs))
			}
		}
	}

	return next(ctx, tx, simulate)
}

// AnteDecorator
func (ad AnteRestrictUbedrockDecorator) AnteHandle(ctx sdk.Context, tx sdk.Tx, simulate bool, next sdk.AnteHandler) (sdk.Context, error) {
	fmt.Printf("[LOG] AnteRestrictUbedrockDecorator - AnteHandle - LINE 59\n")
	fmt.Printf("[LOG] AnteRestrictUbedrockDecorator - AnteHandle - LINE 62\n")
	sigTx, ok := tx.(authsigning.SigVerifiableTx)
	if !ok {
		return ctx, sdkerrors.Wrap(sdkerrors.ErrTxDecode, "invalid transaction type")
	}
	sigTxSignatures, err := sigTx.GetSignaturesV2()
	if err != nil {
		return ctx, sdkerrors.Wrap(err, "getting signatures of tx is failed")
	}

	messages := sigTx.GetMsgs()
	fmt.Printf("[LOG] AnteRestrictUbedrockDecorator - AnteHandle - messages : %v\n", messages)

	msgCreateAccount, ok := messages[0].(*types.MsgCreateAccount)

	if len(messages) == 1 && ok {
		pubkey := sigTxSignatures[0].PubKey
		address := sdk.AccAddress(pubkey.Address().Bytes())

		if address.String() != msgCreateAccount.Creator {
			return ctx, sdkerrors.Wrap(sdkerrors.ErrInvalidAddress, "mismatch between signature pubkey and requester address")
		}
		if msgCreateAccount.Token == "ubedrock" {
			fmt.Printf("[LOG] AnteRestrictUbedrockDecorator - AnteHandle - messages : %v\n", msgCreateAccount.Token)
			fmt.Printf("[LOG] AnteRestrictUbedrockDecorator - AnteHandle - Do limit ubedrock account")
		}
	}
	// sigTxSignatures, err := sigTx.GetSignaturesV2()
	// if err != nil {
	// 	return ctx, sdkerrors.Wrap(err, "getting signatures of tx is failed")
	// }

	// msgCreateAccount, ok := messages[0].(*types.MsgCreateAccount)
	return next(ctx, tx, simulate)
}
