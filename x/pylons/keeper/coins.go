package keeper

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"

	"github.com/Pylons-tech/pylons/x/pylons/types"
)

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

func (k Keeper) MintCoins(ctx sdk.Context, minterName string, amounts sdk.Coins) error {

	err := k.bankKeeper.MintCoins(ctx, minterName, amounts)
	if err != nil {
		return sdkerrors.Wrap(err, "unable to mint coins")
	}

	return nil
}
