package keeper

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// ProcessPaymentInfos issues coins based on provided paymentInfos to the senderAddr
func (k Keeper) RefundPayments(ctx sdk.Context, paymentInfos []types.PaymentInfo) error {
	paymentProcessors := k.PaymentProcessors(ctx)
	for _, pi := range paymentInfos {
		if !k.HasPaymentInfo(ctx, pi.PurchaseId) {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "invalid purchase ID")
		}

		found := false
		for _, pp := range paymentProcessors {
			if pi.ProcessorName == pp.Name {
				found = true

				addr, _ := sdk.AccAddressFromBech32(pi.PayerAddr)

				amt := pi.Amount
				// account for network fees
				burnAmt := amt.ToDec().Mul(pp.ProcessorPercentage).RoundInt()
				feesAmt := amt.ToDec().Mul(pp.ValidatorsPercentage).RoundInt()

				mintCoins := sdk.NewCoins(sdk.NewCoin(pp.CoinDenom, pi.Amount))
				burnCoins := sdk.NewCoins(sdk.NewCoin(pp.CoinDenom, burnAmt))
				feesCoins := sdk.NewCoins(sdk.NewCoin(pp.CoinDenom, feesAmt))


				// mint token, pay for fees
				err := k.RevertMintCreditToAddr(ctx, addr, mintCoins, burnCoins, feesCoins)
				if err != nil {
					return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
				}

				k.RemovePaymentInfo(ctx, pi)
				break
			}
		}
		if !found {
			return sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "could not find %s among valid payment processors", pi.ProcessorName)
		}
	}

	return nil
}
