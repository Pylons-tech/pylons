package network

import (
	"encoding/json"
	"fmt"
	"os"
	"testing"
	"time"

	pruningtypes "github.com/cosmos/cosmos-sdk/pruning/types"
	"github.com/cosmos/cosmos-sdk/server"
	"github.com/spf13/cobra"

	"github.com/cosmos/cosmos-sdk/client/flags"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"

	"github.com/Pylons-tech/pylons/x/pylons/client/cli"

	"github.com/cosmos/cosmos-sdk/codec"

	"github.com/Pylons-tech/pylons/x/pylons/types"

	"github.com/cosmos/cosmos-sdk/baseapp"
	"github.com/cosmos/cosmos-sdk/crypto/hd"
	"github.com/cosmos/cosmos-sdk/crypto/keyring"
	servertypes "github.com/cosmos/cosmos-sdk/server/types"
	"github.com/cosmos/cosmos-sdk/simapp"
	"github.com/cosmos/cosmos-sdk/testutil/network"
	sdk "github.com/cosmos/cosmos-sdk/types"
	authtypes "github.com/cosmos/cosmos-sdk/x/auth/types"
	tmrand "github.com/tendermint/tendermint/libs/rand"
	tmdb "github.com/tendermint/tm-db"

	"github.com/Pylons-tech/pylons/app"
)

type (
	Network = network.Network
	Config  = network.Config
)

type startArgs struct {
	algo          string
	apiAddress    string
	chainID       string
	enableLogging bool
	grpcAddress   string
	minGasPrices  string
	numValidators int
	outputDir     string
	printMnemonic bool
	rpcAddress    string
}

var (
	flagNodeDirPrefix     = "node-dir-prefix"
	flagNumValidators     = "v"
	flagOutputDir         = "output-dir"
	flagNodeDaemonHome    = "node-daemon-home"
	flagStartingIPAddress = "starting-ip-address"
	flagEnableLogging     = "enable-logging"
	flagGRPCAddress       = "grpc.address"
	flagRPCAddress        = "rpc.address"
	flagAPIAddress        = "api.address"
	flagPrintMnemonic     = "print-mnemonic"
)

type initArgs struct {
	algo              string
	chainID           string
	keyringBackend    string
	minGasPrices      string
	nodeDaemonHome    string
	nodeDirPrefix     string
	numValidators     int
	outputDir         string
	startingIPAddress string
	accountType       string
}

func addTestnetFlagsToCmd(cmd *cobra.Command) {
	cmd.Flags().Int(flagNumValidators, 4, "Number of validators to initialize the testnet with")
	cmd.Flags().StringP(flagOutputDir, "o", "./.testnets", "Directory to store initialization data for the testnet")
	cmd.Flags().String(flags.FlagChainID, "", "genesis file chain-id, if left blank will be randomly created")
	cmd.Flags().String(server.FlagMinGasPrices, fmt.Sprintf("0.000006%s", sdk.DefaultBondDenom), "Minimum gas prices to accept for transactions; All fees in a tx must meet this minimum (e.g. 0.01photino,0.001stake)")
	cmd.Flags().String(flags.FlagKeyAlgorithm, string(hd.Secp256k1Type), "Key signing algorithm to generate keys for")
}

// New creates instance with fully configured cosmos network.
// Accepts optional config, that will be used in place of the DefaultConfig() if provided.
func New(t *testing.T, configs ...network.Config) *network.Network {
	if len(configs) > 1 {
		panic("at most one config should be provided")
	}
	var cfg network.Config
	if len(configs) == 0 {
		cfg = DefaultConfig()
	} else {
		cfg = configs[0]
	}

	networkConfig := network.DefaultConfig()
	args := initArgs{}

	// Default networkConfig.ChainID is random, and we should only override it if chainID provided
	// is non-empty
	if args.chainID != "" {
		networkConfig.ChainID = args.chainID
	}
	networkConfig.SigningAlgo = args.algo
	networkConfig.MinGasPrices = args.minGasPrices
	networkConfig.NumValidators = args.numValidators
	networkConfig.EnableTMLogging = args.enableLogging
	networkConfig.RPCAddress = args.rpcAddress
	networkConfig.APIAddress = args.apiAddress
	networkConfig.GRPCAddress = args.grpcAddress
	networkConfig.PrintMnemonic = args.printMnemonic
	networkLogger := network.NewCLILogger(cmd)

	baseDir := fmt.Sprintf("%s/%s", args.outputDir, networkConfig.ChainID)
	if _, err := os.Stat(baseDir); !os.IsNotExist(err) {
		return fmt.Errorf(
			"testnests directory already exists for chain-id '%s': %s, please remove or select a new --chain-id",
			networkConfig.ChainID, baseDir)
	}

	net, err := network.New(networkLogger, baseDir, cfg)
	if err != nil {
		panic(err)
	}
	t.Cleanup(net.Cleanup)

	// create accounts for the validators
	for i, val := range net.Validators {
		ctx := val.ClientCtx
		addr := val.Address.String()
		flags := []string{
			fmt.Sprintf("--%s=%s", flags.FlagFrom, addr),
			fmt.Sprintf("--%s=true", flags.FlagSkipConfirmation),
			fmt.Sprintf("--%s=%s", flags.FlagBroadcastMode, flags.BroadcastBlock),
			fmt.Sprintf("--%s=%s", flags.FlagFees, sdk.NewCoins(sdk.NewCoin(net.Config.BondDenom, sdk.NewInt(10))).String()),
		}

		args := []string{fmt.Sprintf("val%d", i)}
		args = append(args, flags...)
		_, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdCreateAccount(), args)
		require.NoError(t, err)
		// var resp sdk.TxResponse
		// require.NoError(t, ctx.JSONCodec.UnmarshalJSON(out.Bytes(), &resp))
	}

	return net
}

// DefaultConfig will initialize config for the network with custom application,
// genesis and single validator. All other parameters are inherited from cosmos-sdk/testutil/network.DefaultConfig
func DefaultConfig() network.Config {
	encoding := app.MakeEncodingConfig()

	genState := app.ModuleBasics.DefaultGenesis(encoding.Codec)
	genState["pylons"] = CustomGenesisHelper(encoding.Codec)

	return network.Config{
		Codec:             encoding.Codec,
		TxConfig:          encoding.TxConfig,
		LegacyAmino:       encoding.Amino,
		InterfaceRegistry: encoding.InterfaceRegistry,
		AccountRetriever:  authtypes.AccountRetriever{},
		AppConstructor: func(val network.Validator) servertypes.Application {
			return app.New(
				val.Ctx.Logger, tmdb.NewMemDB(), nil, true, map[int64]bool{}, val.Ctx.Config.RootDir, 0,
				encoding,
				simapp.EmptyAppOptions{},
				baseapp.SetPruning(pruningtypes.NewPruningOptionsFromString(val.AppConfig.Pruning)),
				baseapp.SetMinGasPrices(val.AppConfig.MinGasPrices),
			)
		},
		GenesisState:    genState,
		TimeoutCommit:   2 * time.Second,
		ChainID:         "chain-" + tmrand.Str(6),
		NumValidators:   1,
		BondDenom:       sdk.DefaultBondDenom,
		MinGasPrices:    fmt.Sprintf("0%s", sdk.DefaultBondDenom),
		AccountTokens:   sdk.TokensFromConsensusPower(1_000_000, sdk.DefaultPowerReduction),
		StakingTokens:   sdk.TokensFromConsensusPower(1_000_000, sdk.DefaultPowerReduction),
		BondedTokens:    sdk.TokensFromConsensusPower(30, sdk.DefaultPowerReduction),
		PruningStrategy: pruningtypes.PruningOptionNothing,
		CleanupDir:      true,
		SigningAlgo:     string(hd.Secp256k1Type),
		KeyringOptions:  []keyring.Option{},
	}
}

// CustomGenesisHelper returns the pylons module's custom genesis state.
func CustomGenesisHelper(cdc codec.Codec) json.RawMessage {
	return cdc.MustMarshalJSON(types.NetworkTestGenesis())
}

// ConfigWithMaxTxsInBlock will initialize config for the network with custom application,
// genesis and single validator.
func ConfigWithMaxTxsInBlock(maxTxsInBlock uint64) network.Config {
	encoding := app.MakeEncodingConfig()

	genState := app.ModuleBasics.DefaultGenesis(encoding.Codec)
	genesisPylons := types.NetworkTestGenesis()
	genesisPylons.Params.MaxTxsInBlock = maxTxsInBlock

	genState["pylons"] = encoding.Codec.MustMarshalJSON(genesisPylons)

	return network.Config{
		Codec:             encoding.Codec,
		TxConfig:          encoding.TxConfig,
		LegacyAmino:       encoding.Amino,
		InterfaceRegistry: encoding.InterfaceRegistry,
		AccountRetriever:  authtypes.AccountRetriever{},
		AppConstructor: func(val network.Validator) servertypes.Application {
			return app.New(
				val.Ctx.Logger, tmdb.NewMemDB(), nil, true, map[int64]bool{}, val.Ctx.Config.RootDir, 0,
				encoding,
				simapp.EmptyAppOptions{},
				baseapp.SetPruning(storetypes.NewPruningOptionsFromString(val.AppConfig.Pruning)),
				baseapp.SetMinGasPrices(val.AppConfig.MinGasPrices),
			)
		},
		GenesisState:    genState,
		TimeoutCommit:   2 * time.Second,
		ChainID:         "chain-" + tmrand.NewRand().Str(6),
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
