package types

import (
	sdk "github.com/cosmos/cosmos-sdk/types"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
	stakingtypes "github.com/cosmos/cosmos-sdk/x/staking/types"
	transfertypes "github.com/cosmos/ibc-go/v3/modules/apps/transfer/types"
)

// BankKeeper defines the expected interface needed to retrieve account balances.
type BankKeeper interface {
	BurnCoins(ctx sdk.Context, moduleName string, amt sdk.Coins) error
	GetBalance(ctx sdk.Context, addr sdk.AccAddress, denom string) sdk.Coin
	IsSendEnabledCoin(ctx sdk.Context, coin sdk.Coin) bool
	IsSendEnabledCoins(ctx sdk.Context, coins ...sdk.Coin) error
	MintCoins(ctx sdk.Context, moduleName string, amt sdk.Coins) error
	SendCoins(ctx sdk.Context, fromAddr sdk.AccAddress, toAddr sdk.AccAddress, amt sdk.Coins) error
	SendCoinsFromAccountToModule(ctx sdk.Context, senderAddr sdk.AccAddress, recipientModule string, amt sdk.Coins) error
	SendCoinsFromModuleToAccount(ctx sdk.Context, senderModule string, recipientAddr sdk.AccAddress, amt sdk.Coins) error
	SendCoinsFromModuleToModule(ctx sdk.Context, senderModule string, recipientModule string, amt sdk.Coins) error
	SpendableCoins(ctx sdk.Context, addr sdk.AccAddress) sdk.Coins
}

// AccountKeeper defines the contract needed for AccountKeeper related APIs.
// Interface provides support to use non-sdk AccountKeeper for AnteHandler's decorators.
type AccountKeeper interface {
	GetAccount(ctx sdk.Context, addr sdk.AccAddress) authtypes.AccountI
	GetModuleAddress(moduleName string) sdk.AccAddress
	GetNextAccountNumber(ctx sdk.Context) uint64
	GetParams(ctx sdk.Context) (params authtypes.Params)
	NewAccountWithAddress(ctx sdk.Context, addr sdk.AccAddress) authtypes.AccountI
	SetAccount(ctx sdk.Context, acc authtypes.AccountI)
}

// StakingKeeper expected staking keeper (noalias)
type StakingKeeper interface {
	Validator(sdk.Context, sdk.ValAddress) stakingtypes.ValidatorI // get a particular validator by operator address

	// Delegation allows for getting a particular delegation for a given validator
	// and delegator outside the scope of the staking module.
	Delegation(sdk.Context, sdk.AccAddress, sdk.ValAddress) stakingtypes.DelegationI

	// MaxValidators returns the maximum amount of bonded validators
	MaxValidators(ctx sdk.Context) uint32

	IterateDelegations(ctx sdk.Context, delegator sdk.AccAddress,
		fn func(index int64, delegation stakingtypes.DelegationI) (stop bool))

	GetAllSDKDelegations(ctx sdk.Context) []stakingtypes.Delegation
}

// TransferKeeper defines the contract needed for TransferKeeper related APIs.
// Interface provides support to use non-sdk TransferKeeper for AnteHandler's decorators.
type TransferKeeper interface {
	SetDenomTrace(ctx sdk.Context, denomTrace transfertypes.DenomTrace)
	IterateDenomTraces(ctx sdk.Context, cb func(denomTrace transfertypes.DenomTrace) bool)
	GetAllDenomTraces(ctx sdk.Context) transfertypes.Traces
}
