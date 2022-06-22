package app

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	authsigning "github.com/cosmos/cosmos-sdk/x/auth/signing"
)

type AnteSpamMigitationDecorator struct {
	pk PylonsKeeper
}

func NewSpamMigitationAnteDecorator(pylonsmodulekeeper PylonsKeeper) AnteSpamMigitationDecorator {
	return AnteSpamMigitationDecorator{
		pk: pylonsmodulekeeper,
	}
}

// AnteDecorator
func (ad AnteSpamMigitationDecorator) AnteHandle(ctx sdk.Context, tx sdk.Tx, simulate bool, next sdk.AnteHandler) (sdk.Context, error) {
	fmt.Println("simulate")

	fmt.Println(simulate)
	if simulate {
		return next(ctx, tx, simulate)
	}
	sigTx, ok := tx.(authsigning.SigVerifiableTx)
	if !ok {
		return ctx, sdkerrors.Wrap(sdkerrors.ErrTxDecode, "invalid transaction type")
	}

	// get max txs in a block, default is 5
	params := ad.pk.GetParams(ctx)
	maxTxs := params.MaxTxsInBlock

	// increment sequence of all signers
	for _, addr := range sigTx.GetSigners() {
		AccountTrack[addr.String()]++
		if AccountTrack[addr.String()] > maxTxs {
			panic(fmt.Sprintf("maximum txs in block is %d ", maxTxs))
		}
	}

	return next(ctx, tx, simulate)
}
