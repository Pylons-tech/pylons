package keeper

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) CalculateTxSizeFeeAndPay(ctx sdk.Context, marshalledBytes []byte, addr sdk.AccAddress) error {
	fee := types.CalculateTxSizeFee(marshalledBytes, int(k.TxSizeLimitBytes(ctx)), types.DefaultFeePerBytes)
	if fee.Amount.IsPositive() {
		// charge fee
		err := k.bankKeeper.SendCoinsFromAccountToModule(ctx, addr, types.FeeCollectorName, sdk.NewCoins(fee))
		if err != nil {
			return sdkerrors.Wrapf(sdkerrors.ErrInsufficientFunds, "unable to pay sizeOver fee of %d%s", fee.Amount.Int64(), fee.Denom)
		}
	}

	return nil
}
