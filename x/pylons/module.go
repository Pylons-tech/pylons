package pylons

import (
	"encoding/json"

	"github.com/cosmos/cosmos-sdk/codec/types"
	"github.com/grpc-ecosystem/grpc-gateway/runtime"

	"github.com/gorilla/mux"
	"github.com/spf13/cobra"

	"github.com/Pylons-tech/pylons/x/pylons/client/cli/query"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli/tx"
	"github.com/Pylons-tech/pylons/x/pylons/client/rest"
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/types/module"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"

	"github.com/cosmos/cosmos-sdk/client"
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

func (AppModuleBasic) RegisterLegacyAminoCodec(amino *codec.LegacyAmino) {
	panic("implement me")
}

func (AppModuleBasic) RegisterInterfaces(registry types.InterfaceRegistry) {
	panic("implement me")
}

func (AppModuleBasic) RegisterGRPCGatewayRoutes(c client.Context, serveMux *runtime.ServeMux) {
	panic("implement me")
}

// Name returns AppModuleBasic name
func (AppModuleBasic) Name() string {
	return ModuleName
}

// RegisterCodec implements RegisterCodec
func (AppModuleBasic) RegisterCodec(cdc *codec.LegacyAmino) {
	RegisterCodec(cdc)
}

// DefaultGenesis return GenesisState in JSON
func (AppModuleBasic) DefaultGenesis(cdc codec.JSONMarshaler) json.RawMessage {
	return ModuleCdc.MustMarshalJSON(DefaultGenesisState())
}

// ValidateGenesis do validation check of the Genesis
func (AppModuleBasic) ValidateGenesis(cdc codec.JSONMarshaler, cl client.TxEncodingConfig, bz json.RawMessage) error {
	var data GenesisState
	err := ModuleCdc.UnmarshalJSON(bz, &data)
	if err != nil {
		return err
	}
	// Once json successfully marshalled, passes along to genesis.go
	return ValidateGenesis(data)
}

// RegisterRESTRoutes rest routes
func (AppModuleBasic) RegisterRESTRoutes(ctx client.Context, rtr *mux.Router) {
	rest.RegisterRoutes(ctx, rtr, ModuleCdc, StoreKey)
}

// GetQueryCmd get the root query command of this module
func (AppModuleBasic) GetQueryCmd() *cobra.Command {
	pylonsQueryCmd := &cobra.Command{
		Use:   RouterKey,
		Short: "Querying commands for the pylons module",
	}
	pylonsQueryCmd.AddCommand(
		query.GetPylonsBalance(StoreKey, cdc),
		query.CheckGoogleIAPOrder(StoreKey, cdc),
		query.GetCookbook(StoreKey, cdc),
		query.GetExecution(StoreKey, cdc),
		query.GetItem(StoreKey),
		query.GetTrade(StoreKey, cdc),
		query.GetRecipe(StoreKey, cdc),
		query.ListCookbook(StoreKey, cdc),
		query.GetLockedCoins(StoreKey, cdc),
		query.GetLockedCoinDetails(StoreKey, cdc),
		query.ListRecipes(StoreKey, cdc),
		query.ListRecipesByCookbook(StoreKey, cdc),
		query.ListShortenRecipes(StoreKey, cdc),
		query.ListShortenRecipesByCookbook(StoreKey, cdc),
		query.ItemsBySender(StoreKey, cdc),
		query.ListExecutions(StoreKey, cdc),
		query.ListTrade(StoreKey, cdc))

	pylonsQueryCmd.PersistentFlags().String("node", "tcp://localhost:26657", "<host>:<port> to Tendermint RPC interface for this chain")

	return pylonsQueryCmd
}

// GetTxCmd get the root tx command of this module
func (AppModuleBasic) GetTxCmd() *cobra.Command {
	pylonsTxCmd := &cobra.Command{
		Use:   RouterKey,
		Short: "Pylons transactions subcommands",
	}

	pylonsTxCmd.AddCommand(
		tx.CreateAccount(cdc),
		tx.GetPylons(cdc),
		tx.GoogleIAPGetPylons(cdc),
		tx.SendPylons(cdc),
		tx.SendCoins(cdc),
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
	bankKeeper bankkeeper.Keeper
}
}

func (am AppModule) LegacyQuerierHandler(amino *codec.LegacyAmino) sdk.Querier {
	panic("implement me")
}

func (am AppModule) RegisterServices(configurator module.Configurator) {
	panic("implement me")
}

// NewAppModule creates a new AppModule Object
func NewAppModule(k keep.Keeper, bankKeeper bankkeeper.Keeper) AppModule {
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
func (am AppModule) Route() sdk.Route {
	return sdk.NewRoute(RouterKey, NewHandler(am.keeper))
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
func (am AppModule) InitGenesis(ctx sdk.Context, cdc codec.JSONMarshaler, data json.RawMessage) []abci.ValidatorUpdate {
	var genesisState GenesisState
	ModuleCdc.MustUnmarshalJSON(data, &genesisState)
	InitGenesis(ctx, am.keeper, genesisState)
	return []abci.ValidatorUpdate{}
}

// ExportGenesis is a function for export genesis
func (am AppModule) ExportGenesis(ctx sdk.Context, cdc codec.JSONMarshaler) json.RawMessage {
	gs := ExportGenesis(ctx, am.keeper)
	return ModuleCdc.MustMarshalJSON(gs)
}
