package pylons

import (
	"encoding/json"

	"github.com/gorilla/mux"
	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/client/cli/query"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli/tx"
	"github.com/Pylons-tech/pylons/x/pylons/client/rest"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/types/module"
	"github.com/cosmos/cosmos-sdk/x/bank"

	"github.com/cosmos/cosmos-sdk/client/context"
	sdk "github.com/cosmos/cosmos-sdk/types"
	abci "github.com/tendermint/tendermint/abci/types"
)

// type check to ensure the interface is properly implemented
var (
	_ module.AppModule      = AppModule{}
	_ module.AppModuleBasic = AppModuleBasic{}
)

// AppModuleBasic is app module basics object
type AppModuleBasic struct{}

// Name returns AppModuleBasic name
func (AppModuleBasic) Name() string {
	return ModuleName
}

// RegisterCodec implements RegisterCodec
func (AppModuleBasic) RegisterCodec(cdc *codec.Codec) {
	RegisterCodec(cdc)
}

// DefaultGenesis return GenesisState in JSON
func (AppModuleBasic) DefaultGenesis() json.RawMessage {
	return ModuleCdc.MustMarshalJSON(DefaultGenesisState())
}

// ValidateGenesis do validation check of the Genesis
func (AppModuleBasic) ValidateGenesis(bz json.RawMessage) error {
	var data GenesisState
	err := ModuleCdc.UnmarshalJSON(bz, &data)
	if err != nil {
		return err
	}
	// Once json successfully marshalled, passes along to genesis.go
	return ValidateGenesis(data)
}

// RegisterRESTRoutes rest routes
func (AppModuleBasic) RegisterRESTRoutes(ctx context.CLIContext, rtr *mux.Router) {
	rest.RegisterRoutes(ctx, rtr, ModuleCdc, StoreKey)
}

// GetQueryCmd get the root query command of this module
func (AppModuleBasic) GetQueryCmd(cdc *codec.Codec) *cobra.Command {
	pylonsQueryCmd := &cobra.Command{
		Use:   RouterKey,
		Short: "Querying commands for the pylons module",
	}
	pylonsQueryCmd.AddCommand(
		query.GetPylonsBalance(StoreKey, cdc),
		query.GetCookbook(StoreKey, cdc),
		query.GetExecution(StoreKey, cdc),
		query.GetItem(StoreKey, cdc),
		query.GetTrade(StoreKey, cdc),
		query.GetRecipe(StoreKey, cdc),
		query.ListCookbook(StoreKey, cdc),
		query.ListLockedCoins(StoreKey, cdc),
		query.ListRecipes(StoreKey, cdc),
		query.ListShortenRecipes(StoreKey, cdc),
		query.ItemsBySender(StoreKey, cdc),
		query.ListExecutions(StoreKey, cdc),
		query.ListTrade(StoreKey, cdc))

	pylonsQueryCmd.PersistentFlags().String("node", "tcp://localhost:26657", "<host>:<port> to Tendermint RPC interface for this chain")

	return pylonsQueryCmd
}

// GetTxCmd get the root tx command of this module
func (AppModuleBasic) GetTxCmd(cdc *codec.Codec) *cobra.Command {
	pylonsTxCmd := &cobra.Command{
		Use:   RouterKey,
		Short: "Pylons transactions subcommands",
	}

	pylonsTxCmd.AddCommand(
		tx.CreateAccount(cdc),
		tx.GetPylons(cdc),
		tx.SendPylons(cdc),
		tx.SendItems(StoreKey, cdc),
		tx.CreateCookbook(cdc),
		tx.PrivateKeySign(cdc),
		tx.ComputePrivateKey(cdc),
		tx.UpdateCookbook(cdc),
		tx.FiatItem(cdc))

	pylonsTxCmd.PersistentFlags().String("node", "tcp://localhost:26657", "<host>:<port> to Tendermint RPC interface for this chain")
	pylonsTxCmd.PersistentFlags().String("keyring-backend", "os", "Select keyring's backend (os|file|test)")
	pylonsTxCmd.PersistentFlags().String("from", "", "Name or address of private key with which to sign")
	pylonsTxCmd.PersistentFlags().String("broadcast-mode", "sync", "Transaction broadcasting mode (sync|async|block)")

	return pylonsTxCmd
}

// AppModule manages keeper and bankKeeper along with AppModuleBasic
type AppModule struct {
	AppModuleBasic
	keeper     keep.Keeper
	bankKeeper bank.Keeper
}

// NewAppModule creates a new AppModule Object
func NewAppModule(k keep.Keeper, bankKeeper bank.Keeper) AppModule {
	return AppModule{
		AppModuleBasic: AppModuleBasic{},
		keeper:         k,
		bankKeeper:     bankKeeper,
	}
}

// Name returns AppModule name
func (AppModule) Name() string {
	return ModuleName
}

// RegisterInvariants registers invariants
func (am AppModule) RegisterInvariants(ir sdk.InvariantRegistry) {}

// Route returns router key
func (am AppModule) Route() string {
	return RouterKey
}

// NewHandler returns module handler
func (am AppModule) NewHandler() sdk.Handler {
	return NewHandler(am.keeper)
}

// QuerierRoute returns QuerierRoute
func (am AppModule) QuerierRoute() string {
	return QuerierRoute
}

// NewQuerierHandler return NewQuerier
func (am AppModule) NewQuerierHandler() sdk.Querier {
	return NewQuerier(am.keeper)
}

// BeginBlock is a begin block function
func (am AppModule) BeginBlock(_ sdk.Context, _ abci.RequestBeginBlock) {}

// EndBlock is a end block function
func (am AppModule) EndBlock(sdk.Context, abci.RequestEndBlock) []abci.ValidatorUpdate {
	return []abci.ValidatorUpdate{}
}

// InitGenesis is a function for init genesis
func (am AppModule) InitGenesis(ctx sdk.Context, data json.RawMessage) []abci.ValidatorUpdate {
	var genesisState GenesisState
	ModuleCdc.MustUnmarshalJSON(data, &genesisState)
	InitGenesis(ctx, am.keeper, genesisState)
	return []abci.ValidatorUpdate{}
}

// ExportGenesis is a function for export genesis
func (am AppModule) ExportGenesis(ctx sdk.Context) json.RawMessage {
	gs := ExportGenesis(ctx, am.keeper)
	return ModuleCdc.MustMarshalJSON(gs)
}
