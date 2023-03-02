package app

import (
	"fmt"

	"github.com/Pylons-tech/pylons/app/params"
	sdk "github.com/cosmos/cosmos-sdk/types"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
	stakingtypes "github.com/cosmos/cosmos-sdk/x/staking/types"
)

const (
	// mainnet master wallet address
	MasterWallet = "pylo1vnwhaymaazugzz9ln2sznddveyed6shz3x8xwl"
)

// FixBondedTokensPool fixes the bonded tokens pool following the v1 upgrade
func (app *PylonsApp) FixBondedTokensPool(ctx sdk.Context) {
	ctx.Logger().Info("Correcting bonded_tokens_pool")

	bk := app.BankKeeper
	bondedTokensPoolAddress := authtypes.NewModuleAddress(stakingtypes.BondedPoolName)
	multisigAddress := sdk.MustAccAddressFromBech32(MasterWallet)

	// Account currently has 1 BEDROCK
	// There is currently 15202 BEDROCK Total Power Delegated
	// Transferring the missing accounting from multisig to bonded_tokens_pool
	totalPower := app.StakingKeeper.GetLastTotalPower(ctx)

	bondeTokensPoolBalance := bk.GetBalance(ctx, bondedTokensPoolAddress, params.StakingBaseCoinUnit)
	bondeTokensPoolDelta := totalPower.Sub(bondeTokensPoolBalance.Amount)

	bondeTokensPoolAdjustment := sdk.NewCoins(sdk.NewCoin(params.StakingBaseCoinUnit, bondeTokensPoolDelta))
	err := bk.SendCoinsFromAccountToModule(ctx, multisigAddress, stakingtypes.BondedPoolName, bondeTokensPoolAdjustment)
	if err != nil {
		panic(err)
	}

	// Double check that the balance is expected
	bondeTokensPoolCorrected := bk.GetBalance(ctx, bondedTokensPoolAddress, params.StakingBaseCoinUnit)
	ctx.Logger().Info(fmt.Sprintf("bonded_tokens_pools now has %v\n", bondeTokensPoolCorrected))
}
