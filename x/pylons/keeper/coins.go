package keeper

import (
	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

func (k Keeper) SendRewardsFromFeeCollector(ctx sdk.Context, addr sdk.AccAddress, amounts sdk.Coins) error {
	feeCollector := v1beta1.FeeCollectorName

	// send coins
	err := k.bankKeeper.SendCoinsFromModuleToAccount(ctx, feeCollector, addr, amounts)

	return err
}

func (k Keeper) MintCoinsToAddr(ctx sdk.Context, addr sdk.AccAddress, amounts sdk.Coins) error {
	coinMint := v1beta1.CoinsIssuerName

	// mint coins to minter module account
	err := k.MintCoins(ctx, coinMint, amounts)
	if err != nil {
		return err
	}

	// send coins to the address
	err = k.bankKeeper.SendCoinsFromModuleToAccount(ctx, coinMint, addr, amounts)
	if err != nil {
		return err
	}

	return nil
}

func (k Keeper) MintCreditToAddr(ctx sdk.Context, addr sdk.AccAddress, amounts, burn, fees sdk.Coins) error {
	ppMacc := v1beta1.PaymentsProcessorName
	feesMacc := v1beta1.FeeCollectorName

	// mint coins to minter module account
	err := k.MintCoins(ctx, ppMacc, amounts)
	if err != nil {
		return err
	}

	// burn amount after it has been minted - keep clear track of fees paid to paymentProcessor
	err = k.BurnCoins(ctx, ppMacc, burn)
	if err != nil {
		return err
	}

	actualAmt := amounts
	for _, c := range burn {
		actualAmt = actualAmt.Sub(c)
	}

	for _, c := range fees {
		actualAmt = actualAmt.Sub(c)
	}

	// send coins to the address
	err = k.bankKeeper.SendCoinsFromModuleToAccount(ctx, ppMacc, addr, actualAmt)
	if err != nil {
		return err
	}

	// send fees to the fee collector
	err = k.bankKeeper.SendCoinsFromModuleToModule(ctx, ppMacc, feesMacc, fees)
	if err != nil {
		return err
	}

	return nil
}

func (k Keeper) BurnCreditFromAddr(ctx sdk.Context, addr sdk.AccAddress, amt sdk.Coins) error {
	macc := v1beta1.PaymentsProcessorName

	// send coins to the module account
	err := k.bankKeeper.SendCoinsFromAccountToModule(ctx, addr, macc, amt)
	if err != nil {
		return err
	}

	// burn the amount
	err = k.BurnCoins(ctx, macc, amt)
	if err != nil {
		return err
	}

	return nil
}

func (k Keeper) MintCoins(ctx sdk.Context, minterName string, amounts sdk.Coins) error {
	err := k.bankKeeper.MintCoins(ctx, minterName, amounts)
	if err != nil {
		return err
	}

	return nil
}

func (k Keeper) BurnCoins(ctx sdk.Context, minterName string, amounts sdk.Coins) error {
	err := k.bankKeeper.BurnCoins(ctx, minterName, amounts)
	if err != nil {
		return err
	}

	return nil
}
