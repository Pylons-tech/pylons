package keeper

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
)

func (k Keeper) CalculateTxSizeFeeAndPay(ctx sdk.Context, marshalledBytes []byte, addr sdk.AccAddress) error {
	fee := types.CalculateTxSizeFee(marshalledBytes, types.DefaultSizeLimitBytes, types.DefaultFeePerBytes)
	if fee > 0 {
		// charge fee
		coins := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, sdk.NewInt(int64(fee))))
		err := k.bankKeeper.SendCoinsFromAccountToModule(ctx, addr, types.FeeCollectorName, coins)
		if err != nil {
			return sdkerrors.Wrapf(sdkerrors.ErrInsufficientFunds, "unable to pay sizeOver fee of %d%s", fee, types.PylonsCoinDenom)
		}
	}

	return nil
}
