package keeper

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// ProcessPaymentInfos issues coins based on provided paymentInfos to the senderAddr
func (k Keeper) ProcessPaymentInfos(ctx sdk.Context, paymentInfos []types.PaymentInfo, senderAddr sdk.AccAddress) error {
	paymentProcessors := k.PaymentProcessors(ctx)
	for _, pi := range paymentInfos {
		if k.HasPaymentInfo(ctx, pi.PurchaseId) {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, "the purchase ID is already being used")
		}

		found := false
		for _, pp := range paymentProcessors {
			if pi.ProcessorName == pp.Name {
				found = true

				addr, _ := sdk.AccAddressFromBech32(pi.PayerAddr)
				if !addr.Equals(senderAddr) {
					return sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "address for purchase %s do not match", pi.PurchaseId)
				}

				amt := pi.Amount
				// account for network fees
				burnAmt := sdk.NewDecFromInt(amt).Mul(pp.ProcessorPercentage).RoundInt()
				feesAmt := sdk.NewDecFromInt(amt).Mul(pp.ValidatorsPercentage).RoundInt()

				mintCoins := sdk.NewCoins(sdk.NewCoin(pp.CoinDenom, pi.Amount))
				burnCoins := sdk.NewCoins(sdk.NewCoin(pp.CoinDenom, burnAmt))
				feesCoins := sdk.NewCoins(sdk.NewCoin(pp.CoinDenom, feesAmt))

				err := pp.ValidatePaymentInfo(pi)
				if err != nil {
					return sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "error validating purchase %s - %s", pi.PurchaseId, err.Error())
				}

				// mint token, pay for fees
				err = k.MintCreditToAddr(ctx, addr, mintCoins, burnCoins, feesCoins)
				if err != nil {
					return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
				}

				k.SetPaymentInfo(ctx, pi)
				break
			}
		}
		if !found {
			return sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "could not find %s among valid payment processors", pi.ProcessorName)
		}
	}

	return nil
}

// ValidatePaymentInfo verifies that the receipts provided can cover for the entire balance of coins controlled by paymentProcessors
// where sendEnable is false
func (k Keeper) ValidatePaymentInfo(ctx sdk.Context, paymentInfos []types.PaymentInfo, toPay sdk.Coins) error {
	// when paying, cannot use existing balance for denoms controlled by paymentProcessors where send is disabled
	// we need to do this check before processing payments
	// first, build denomsPaymentInfoMap and paymentProcessofInfoMap from the provided paymentInfos
	allPaymentProcessors := k.PaymentProcessors(ctx)
	denomsPaymentInfoMap := make(map[string][]types.PaymentInfo)
	paymentInfoProcessorMap := make(map[string]types.PaymentProcessor)
	for _, pi := range paymentInfos {
		err := sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "could not find %s among valid payment processors", pi.ProcessorName)
		for _, pp := range allPaymentProcessors {
			if pi.ProcessorName == pp.Name {
				err = nil
				denomsPaymentInfoMap[pp.CoinDenom] = append(denomsPaymentInfoMap[pp.CoinDenom], pi)
				paymentInfoProcessorMap[pi.PurchaseId] = pp
				break
			}
		}
		if err != nil {
			return err
		}
	}
	// iterate through toPay coins, check if receipts provided would cover for required amounts of coins controlled by
	// paymentProcessors and where sendEnable is false
	for _, coin := range toPay {
		checkReceipts := false
		// we split searching for a paymentProcessor coin and checking receipts since multiple paymentProcessors
		// could potentially issue the same coin
		for _, pp := range allPaymentProcessors {
			if coin.Denom == pp.CoinDenom {
				// checking receipts in advance is only required if send enable is false
				if !k.bankKeeper.IsSendEnabledCoin(ctx, coin) {
					checkReceipts = true
				}
				break
			}
		}
		if checkReceipts {
			// check if total amount in receipts for this coin is enough to cover completely, since existing balance
			// cannot be used
			mintAmt := sdk.ZeroInt()
			for _, paymentInfo := range denomsPaymentInfoMap[coin.Denom] {
				mintAmt = mintAmt.Add(paymentInfo.Amount)
				paymentProcessor := paymentInfoProcessorMap[paymentInfo.PurchaseId]
				// account for network fees
				amt := paymentInfo.Amount
				burnAmt := sdk.NewDecFromInt(amt).Mul(paymentProcessor.ProcessorPercentage).RoundInt()
				feesAmt := sdk.NewDecFromInt(amt).Mul(paymentProcessor.ValidatorsPercentage).RoundInt()
				coin = coin.AddAmount(burnAmt).AddAmount(feesAmt)
			}
			if mintAmt.LT(coin.Amount) {
				mintCoin := sdk.NewCoin(coin.Denom, mintAmt)
				return sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "required %s but only provided receipts for %s", coin.String(), mintCoin.String())
			}
		}
	}
	return nil
}

// VerifyPaymentInfos verifies payment info for stripe refund
func (k Keeper) VerifyPaymentInfos(ctx sdk.Context, paymentInfos *types.PaymentInfo, senderAddr sdk.AccAddress) error {
	paymentProcessors := k.PaymentProcessors(ctx)

	found := false
	for _, pp := range paymentProcessors {
		// find respective payment processor
		if paymentInfos.ProcessorName == pp.Name {
			found = true

			addr, _ := sdk.AccAddressFromBech32(paymentInfos.PayerAddr)
			if !addr.Equals(senderAddr) {
				return sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "address for purchase %s do not match", paymentInfos.PurchaseId)
			}

			// validate signature of payment
			err := pp.ValidatePaymentInfo(*paymentInfos)
			if err != nil {
				return sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "error validating purchase %s - %s", paymentInfos.PurchaseId, err.Error())
			}

			// set the payment info so it cannot be used again later
			k.SetPaymentInfo(ctx, *paymentInfos)
			break
		}
	}
	if !found {
		return sdkerrors.Wrapf(sdkerrors.ErrInvalidRequest, "could not find %s among valid payment processors", paymentInfos.ProcessorName)
	}

	return nil
}
