package app

import (
	pylonsmodulekeeper "github.com/Pylons-tech/pylons/x/pylons/keeper"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	authsigning "github.com/cosmos/cosmos-sdk/x/auth/signing"
)

type AnteSpamMigitationDecorator struct {
	pk pylonsmodulekeeper.Keeper
}

func NewSpamMigitationAnteDecorator(pylonsmodulekeeper pylonsmodulekeeper.Keeper) AnteSpamMigitationDecorator {
	return AnteSpamMigitationDecorator{
		pk: pylonsmodulekeeper,
	}
}

// AnteDecorator
func (ad AnteSpamMigitationDecorator) AnteHandle(ctx sdk.Context, tx sdk.Tx, simulate bool, next sdk.AnteHandler) (sdk.Context, error) {
	sigTx, ok := tx.(authsigning.SigVerifiableTx)
	if !ok {
		return ctx, sdkerrors.Wrap(sdkerrors.ErrTxDecode, "invalid transaction type")
	}

	// get max txs in a block
	params := ad.pk.GetParams(ctx)
	maxTxs := params.MaxTxsInBlock
	// increment sequence of all signers
	for _, addr := range sigTx.GetSigners() {
		AccountTrack[addr.String()]++
		if AccountTrack[addr.String()] > maxTxs {
			return ctx, sdkerrors.Wrapf(sdkerrors.ErrMemoTooLarge, "maximum txs in block is %d ", maxTxs)
		}
	}

	return next(ctx, tx, simulate)
}
