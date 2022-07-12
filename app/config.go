package app

import (
	"encoding/json"
	"fmt"
	"time"

	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/codec"
	storetypes "github.com/cosmos/cosmos-sdk/store/types"
	"github.com/cosmos/cosmos-sdk/testutil/network"

	"github.com/cosmos/cosmos-sdk/baseapp"
	"github.com/cosmos/cosmos-sdk/crypto/hd"
	"github.com/cosmos/cosmos-sdk/crypto/keyring"
	"github.com/cosmos/cosmos-sdk/simapp"
	tmdb "github.com/tendermint/tm-db"

	servertypes "github.com/cosmos/cosmos-sdk/server/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
)

// DefaultConfig returns a default configuration suitable for nearly all
// testing requirements.
func DefaultConfig() network.Config {
	encCfg := MakeEncodingConfig()

	genState := ModuleBasics.DefaultGenesis(encCfg.Codec)
	genState["pylons"] = CustomGenesisHelper(encCfg.Codec)

	return network.Config{
		Codec:             encCfg.Codec,
		TxConfig:          encCfg.TxConfig,
		LegacyAmino:       encCfg.Amino,
		InterfaceRegistry: encCfg.InterfaceRegistry,
		AccountRetriever:  authtypes.AccountRetriever{},
		AppConstructor: func(val network.Validator) servertypes.Application {
			return New(
				val.Ctx.Logger, tmdb.NewMemDB(), nil, true, map[int64]bool{}, val.Ctx.Config.RootDir, 0,
				encCfg,
				simapp.EmptyAppOptions{},
				baseapp.SetPruning(storetypes.NewPruningOptionsFromString(val.AppConfig.Pruning)),
				baseapp.SetMinGasPrices(val.AppConfig.MinGasPrices),
			)
		},
		GenesisState:    ModuleBasics.DefaultGenesis(encCfg.Codec),
		TimeoutCommit:   0 * time.Second,
		ChainID:         "pylons-code-test",
		NumValidators:   1,
		BondDenom:       sdk.DefaultBondDenom,
		MinGasPrices:    fmt.Sprintf("0%s", sdk.DefaultBondDenom),
		AccountTokens:   sdk.TokensFromConsensusPower(1_000_000, sdk.DefaultPowerReduction),
		StakingTokens:   sdk.TokensFromConsensusPower(1_000_000, sdk.DefaultPowerReduction),
		BondedTokens:    sdk.TokensFromConsensusPower(30, sdk.DefaultPowerReduction),
		PruningStrategy: storetypes.PruningOptionNothing,
		CleanupDir:      true,
		SigningAlgo:     string(hd.Secp256k1Type),
		KeyringOptions:  []keyring.Option{},
	}
}

// CustomGenesisHelper returns the pylons module's custom genesis state.
func CustomGenesisHelper(cdc codec.Codec) json.RawMessage {
	return cdc.MustMarshalJSON(types.NetworkTestGenesis())
}
