package v4

import (
	"cosmossdk.io/math"
	pylonskeeper "github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	sdkerrors "github.com/cosmos/cosmos-sdk/types/errors"
	"github.com/cosmos/cosmos-sdk/types/module"
	authkeeper "github.com/cosmos/cosmos-sdk/x/auth/keeper"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"
	stakingkeeper "github.com/cosmos/cosmos-sdk/x/staking/keeper"
	stakingtypes "github.com/cosmos/cosmos-sdk/x/staking/types"
	upgradetypes "github.com/cosmos/cosmos-sdk/x/upgrade/types"
)

const (
	//----------- FAKE ADDRESS---------------//
	// StakeholderDistribution wallet address
	StakeholderDistribution = "pylo1vnwhaymaazugzz9ln2sznddveyed6shz3x8xwl"
	// Incentive Pools wallet address
	IncentivePools = "pylo1vnwhaymaazugzz9ln2sznddveyed6shz3x8xwl"
	// Foundation Discretionary wallet address
	FoundationDiscretionary = "pylo1vnwhaymaazugzz9ln2sznddveyed6shz3x8xwl"
	// Token Presale wallet address
	TkPreSale = "pylo1vnwhaymaazugzz9ln2sznddveyed6shz3x8xwl"
	// Token CF Sale wallet address
	TkCFSale = "pylo1vnwhaymaazugzz9ln2sznddveyed6shz3x8xwl"
	// Token Reg D+S Sale wallet address
	TkRegDSSale = "pylo1vnwhaymaazugzz9ln2sznddveyed6shz3x8xwl"
	// Company Revenue wallet address
	CompanyRevenue = "pylo1vnwhaymaazugzz9ln2sznddveyed6shz3x8xwl"
	// Engineering Hot Wallet wallet address
	EngineHotWal = "pylo1vnwhaymaazugzz9ln2sznddveyed6shz3x8xwl"
	//----------- FAKE ADDRESS---------------//
	LuxFloralisCookBookID = "Easel_CookBook_auto_cookbook_2022_08_31_183723_014"
	LuxFloralisRecipeID   = "Easel_Recipe_auto_recipe_2022_08_31_183729_838"
)

var (
	Accounts = []string{
		StakeholderDistribution,
		IncentivePools,
		FoundationDiscretionary,
		TkPreSale,
		TkCFSale,
		TkRegDSSale,
		CompanyRevenue,
		EngineHotWal,
	}

	TotalUbedrock = math.NewIntFromUint64(1e+15) // 1 bedrock = 1_000_000 ubedrock

	// UbedrockDistribute = map[string]math.Int{
	// 	Accounts[0]: math.NewIntFromUint64(150_000_000_000_000),
	// 	Accounts[1]: math.NewIntFromUint64(150_000_000_000_000),
	// 	Accounts[2]: math.ZeroInt(),
	// 	Accounts[3]: math.NewIntFromUint64(20_000_000_000_000),
	// 	Accounts[4]: math.NewIntFromUint64(40_000_000_000_000),
	// 	Accounts[5]: math.NewIntFromUint64(20_000_000_000_000),
	// 	Accounts[6]: math.NewIntFromUint64(619_999_000_000_000),
	// 	Accounts[7]: math.NewIntFromUint64(1_000_000_000),
	// }
	UbedrockDistribute = map[string]math.Int{
		Accounts[0]: math.NewIntFromUint64(1_000_000_000_000_00),
		Accounts[1]: math.NewIntFromUint64(1_000_000_000_000_00),
		Accounts[2]: math.ZeroInt(),
		Accounts[3]: math.NewIntFromUint64(1_000_000_000_000_00),
		Accounts[4]: math.NewIntFromUint64(1_000_000_000_000_00),
		Accounts[5]: math.NewIntFromUint64(1_000_000_000_000_00),
		Accounts[6]: math.NewIntFromUint64(1_000_000_000_000_00),
		Accounts[7]: math.NewIntFromUint64(1_000_000_000_000_00),
	}
	_ = Accounts
	_ = TotalUbedrock
	_ = UbedrockDistribute

	minStake     = sdk.NewDec(2_000_000)
	IAPAddress   = map[string]bool{}
	Aug8DateUnix = int64(1659916800)
)

func CreateUpgradeHandler(
	mm *module.Manager,
	configurator module.Configurator,
	bankKeeper bankkeeper.Keeper,
	accKeeper *authkeeper.AccountKeeper,
	staking *stakingkeeper.Keeper,
	pylons *pylonskeeper.Keeper,
) upgradetypes.UpgradeHandler {
	return func(ctx sdk.Context, plan upgradetypes.Plan, fromVM module.VersionMap) (module.VersionMap, error) {
		// logger := ctx.Logger()

		if types.IsMainnet(ctx.ChainID()) {

			bankBaseKeeper, _ := bankKeeper.(bankkeeper.BaseKeeper)
			BurnToken(ctx, types.StakingCoinDenom, accKeeper, &bankBaseKeeper, staking)
			BurnToken(ctx, types.StripeCoinDenom, accKeeper, &bankBaseKeeper, staking)
			MintUbedrockForInitialAccount(ctx, &bankBaseKeeper, staking)
			CleanUpylons(ctx, &bankBaseKeeper, pylons)
			RefundLuxFloralis(ctx, pylons)
			RefundIAPNFTBUY(ctx, pylons, accKeeper, &bankBaseKeeper)
		}
		return mm.RunMigrations(ctx, configurator, fromVM)
	}
}

// TODO: Function helper for upgradeHandler
// Burn denom token
func BurnToken(ctx sdk.Context, denom string, accKeeper *authkeeper.AccountKeeper, bank *bankkeeper.BaseKeeper, staking *stakingkeeper.Keeper) {
	if denom == types.StakingCoinDenom {
		// Get coin back from validator
		accounts := accKeeper.GetAllAccounts(ctx)
		for _, acc := range accounts {
			_, ok := acc.(*authtypes.ModuleAccount)
			if !ok {
				GetbackCoinFromVal(ctx, acc.GetAddress(), staking)
			}
		}
	}

	// Get all account balances
	accs := bank.GetAccountsBalances(ctx)
	for _, acc := range accs {
		balance := acc.Coins.AmountOf(denom)
		// Check if denom token amount GT 0
		if balance.GT(math.ZeroInt()) {
			amount := sdk.NewCoin(denom, balance)
			// Send denom token to module
			err := bank.SendCoinsFromAccountToModule(ctx, sdk.MustAccAddressFromBech32(acc.Address), types.PaymentsProcessorName, sdk.NewCoins(amount))
			if err != nil {
				panic(err)
			}
			// Burn denom token in module
			err = bank.BurnCoins(ctx, types.PaymentsProcessorName, sdk.NewCoins(amount))
			if err != nil {
				panic(err)
			}
		}
	}
}

// Mint ubedrock for 8 security account
func MintUbedrockForInitialAccount(ctx sdk.Context, bank *bankkeeper.BaseKeeper, staking *stakingkeeper.Keeper) {
	// Mint coin for module
	err := bank.MintCoins(ctx, types.PaymentsProcessorName, sdk.NewCoins(sdk.NewCoin(types.StakingCoinDenom, TotalUbedrock)))
	if err != nil {
		panic(err)
	}

	// Send coin from module to account
	for _, acc := range Accounts {
		err = bank.SendCoinsFromModuleToAccount(
			ctx,
			types.PaymentsProcessorName,
			sdk.MustAccAddressFromBech32(acc),
			sdk.NewCoins(sdk.NewCoin(types.StakingCoinDenom, UbedrockDistribute[acc])),
		)
		if err != nil {
			panic(err)
		}
	}

	// Send 1 bedrock to each validator = 1_000_000 ubedrock
	vals := staking.GetAllValidators(ctx)
	for _, val := range vals {
		if val.Tokens.LT(minStake.RoundInt()) {
			stakeVal := minStake.RoundInt().Sub(val.Tokens)
			_, err = staking.Delegate(
				ctx,
				sdk.MustAccAddressFromBech32(EngineHotWal),
				stakeVal,
				stakingtypes.Unbonded,
				val,
				true,
			)
			if err != nil {
				panic(err)
			}

		}
	}
}

func GetbackCoinFromVal(ctx sdk.Context, accAddr sdk.AccAddress, staking *stakingkeeper.Keeper) {
	now := ctx.BlockHeader().Time

	// this loop will complete all delegator's active redelegations
	for _, activeRedelegation := range staking.GetRedelegations(ctx, accAddr, 65535) {
		// src/dest validator addresses of this redelegation
		redelegationSrc, _ := sdk.ValAddressFromBech32(activeRedelegation.ValidatorSrcAddress)
		redelegationDst, _ := sdk.ValAddressFromBech32(activeRedelegation.ValidatorDstAddress)

		// set all entry completionTime to now so we can complete redelegation
		for i := range activeRedelegation.Entries {
			activeRedelegation.Entries[i].CompletionTime = now
		}

		staking.SetRedelegation(ctx, activeRedelegation)
		_, err := staking.CompleteRedelegation(ctx, accAddr, redelegationSrc, redelegationDst)
		if err != nil {
			panic(err)
		}
	}

	// this loop will turn all delegator's delegations into unbonding delegations
	for _, delegation := range staking.GetAllDelegatorDelegations(ctx, accAddr) {
		validatorValAddr := delegation.GetValidatorAddr()
		_, found := staking.GetValidator(ctx, validatorValAddr)
		if !found {
			continue
		}
		unStake := delegation.Shares.Sub(minStake)
		if unStake.GT(minStake) {
			_, err := staking.Undelegate(ctx, accAddr, validatorValAddr, unStake) //nolint:errcheck // nolint because otherwise we'd have a time and nothing to do with it.
			if err != nil {
				panic(err)
			}

		}
	}

	// this loop will complete all delegator's unbonding delegations
	for _, unbondingDelegation := range staking.GetAllUnbondingDelegations(ctx, accAddr) {
		// validator address of this unbonding delegation
		validatorStringAddr := unbondingDelegation.ValidatorAddress
		validatorValAddr, _ := sdk.ValAddressFromBech32(validatorStringAddr)

		// set all entry completionTime to now so we can complete unbonding delegation
		for i := range unbondingDelegation.Entries {
			unbondingDelegation.Entries[i].CompletionTime = now
		}
		staking.SetUnbondingDelegation(ctx, unbondingDelegation)
		_, err := staking.CompleteUnbonding(ctx, accAddr, validatorValAddr)
		if err != nil {
			panic(err)
		}
	}
}

func CleanUpylons(ctx sdk.Context, bank *bankkeeper.BaseKeeper, pylons *pylonskeeper.Keeper) {
	accs := bank.GetAccountsBalances(ctx)
	for _, acc := range accs {
		balance := acc.Coins.AmountOf(types.PylonsCoinDenom)
		// Check if upylons token amount GT 0
		if balance.GT(math.ZeroInt()) {
			amount := sdk.NewCoin(types.PylonsCoinDenom, balance)
			// Send upylons token to module
			err := bank.SendCoinsFromAccountToModule(ctx, sdk.MustAccAddressFromBech32(acc.Address), types.PaymentsProcessorName, sdk.NewCoins(amount))
			if err != nil {
				panic(err)
			}
			// Burn upylons token in module
			err = bank.BurnCoins(ctx, types.PaymentsProcessorName, sdk.NewCoins(amount))
			if err != nil {
				panic(err)
			}
		}
	}
	err := MintValidUpylons(ctx, pylons)
	if err != nil {
		panic(err)
	}
}

func MintValidUpylons(ctx sdk.Context, pylons *pylonskeeper.Keeper) error {
	err := MintValidUpylonsGoogleIAP(ctx, pylons)
	if err != nil {
		return err
	}
	err = MintValidUpylonsAppleIAP(ctx, pylons)
	if err != nil {
		return err
	}
	return nil
}

// Mint upylons for address with valid (with IAP))
func MintValidUpylonsGoogleIAP(ctx sdk.Context, pylons *pylonskeeper.Keeper) error {
	for _, googleIAPOder := range pylons.GetAllGoogleIAPOrder(ctx) {
		amountUpylons := GetAmountOfUpylonsMintedByProductID(ctx, googleIAPOder.ProductId)
		addr, _ := sdk.AccAddressFromBech32(googleIAPOder.Creator)

		amt := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, amountUpylons))
		err := pylons.MintCoinsToAddr(ctx, addr, amt)
		if err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
		// To maintain records for IAP addresses
		IAPAddress[googleIAPOder.Creator] = true
	}
	return nil
}

// Mint upylons for address with valid (with IAP))
func MintValidUpylonsAppleIAP(ctx sdk.Context, pylons *pylonskeeper.Keeper) error {
	for _, appleIAPOder := range pylons.GetAllAppleIAPOrder(ctx) {
		amountUpylons := GetAmountOfUpylonsMintedByProductID(ctx, appleIAPOder.ProductId)
		addr, _ := sdk.AccAddressFromBech32(appleIAPOder.Creator)

		amt := sdk.NewCoins(sdk.NewCoin(types.PylonsCoinDenom, amountUpylons))
		err := pylons.MintCoinsToAddr(ctx, addr, amt)
		if err != nil {
			return sdkerrors.Wrap(sdkerrors.ErrInvalidRequest, err.Error())
		}
		// To maintain records for IAP addresses
		IAPAddress[appleIAPOder.Creator] = true
	}
	return nil
}

// Get amount of upylons was minted by product id
func GetAmountOfUpylonsMintedByProductID(ctx sdk.Context, productID string) math.Int {
	// Looping defaultCoinIssuers to get amount upylons by product id
	for _, ci := range types.DefaultCoinIssuers {
		for _, p := range ci.Packages {
			if p.ProductId == productID && ci.CoinDenom == types.PylonsCoinDenom {
				amount := p.Amount
				return amount
			}
		}
	}
	return math.ZeroInt()
}

func RefundIAPNFTBUY(ctx sdk.Context, pylons *pylonskeeper.Keeper, accKeeper *authkeeper.AccountKeeper, bank *bankkeeper.BaseKeeper) {
	// Query All cookbooks on chain
	cookbooks := pylons.GetAllCookbook(ctx)
	for _, cookbook := range cookbooks {
		// Query All recipes made with cookbook on chain
		recipes := pylons.GetAllRecipesByCookbook(ctx, cookbook.Id)
		for _, recipe := range recipes {
			// Check If Recipe is executed atleast once
			if recipe.Entries.ItemOutputs[0].AmountMinted > 0 {
				// Query All Execution Record of the Recipe
				executions := pylons.GetAllExecuteRecipeHis(ctx, cookbook.Id, recipe.Id)
				for _, execution := range executions {
					if execution.CreatedAt >= Aug8DateUnix {
						if IAPAddress[execution.Sender] {
							// If recipe is executed after 8th August, i.e. first IAP purchase
							// If executor has purchased form IAP
							// If amount is in upylons
							amount, _ := sdk.ParseCoinNormalized(execution.Amount)
							if amount.Denom == types.PylonsCoinDenom {
								err := bank.SendCoinsFromAccountToModule(
									ctx,
									sdk.MustAccAddressFromBech32(execution.Sender),
									types.PaymentsProcessorName,
									sdk.NewCoins(amount),
								)
								if err != nil {
									// case: user do not have enough IAP tokens
									continue
								}
								err = bank.SendCoinsFromModuleToAccount(
									ctx,
									types.PaymentsProcessorName,
									sdk.MustAccAddressFromBech32(cookbook.Creator),
									sdk.NewCoins(amount),
								)
								if err != nil {
									panic(err)
								}
							}
						}
					}
				}
			}
		}
	}
}

func RefundLuxFloralis(ctx sdk.Context, pylons *pylonskeeper.Keeper) {
	// Get all execute recipe history by cookbookid and recipe id
	histories := pylons.GetAllExecuteRecipeHis(ctx, LuxFloralisCookBookID, LuxFloralisRecipeID)
	coins, _ := sdk.ParseCoinNormalized(histories[0].Amount)
	// Looping execute recipe history to get amount
	for i := 1; i < len(histories); i++ {
		amount, _ := sdk.ParseCoinNormalized(histories[i].Amount)
		coins = coins.Add(amount)
	}

	addr, _ := sdk.AccAddressFromBech32(histories[0].Receiver)

	err := pylons.MintCoinsToAddr(ctx, addr, sdk.NewCoins(coins))
	if err != nil {
		panic(err)
	}
}
