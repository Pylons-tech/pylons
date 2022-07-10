package keeper

import (
	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (k Keeper) SendRewardsFromFeeCollector(ctx sdk.Context, addr sdk.AccAddress, amounts sdk.Coins) error {
	feeCollector := types.FeeCollectorName

	// send coins
	err := k.bankKeeper.SendCoinsFromModuleToAccount(ctx, feeCollector, addr, amounts)

	return err
}

func (k Keeper) MintCoinsToAddr(ctx sdk.Context, addr sdk.AccAddress, amounts sdk.Coins) error {
	coinMint := types.CoinsIssuerName

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
	ppMacc := types.PaymentsProcessorName
	feesMacc := types.FeeCollectorName

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

	actualAmt := amounts.Sub(burn[0]).Sub(fees[0])

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
	macc := types.PaymentsProcessorName

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
