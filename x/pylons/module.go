package pylons

import (
	"context"
	"encoding/json"

	"github.com/gorilla/mux"
	"github.com/spf13/cobra"

	"github.com/grpc-ecosystem/grpc-gateway/runtime"
	abci "github.com/tendermint/tendermint/abci/types"

	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/codec"
	sdktypes "github.com/cosmos/cosmos-sdk/codec/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/module"
	bankkeeper "github.com/cosmos/cosmos-sdk/x/bank/keeper"

	"github.com/Pylons-tech/pylons/x/pylons/client/cli/query"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli/tx"
	"github.com/Pylons-tech/pylons/x/pylons/client/rest"
	"github.com/Pylons-tech/pylons/x/pylons/handlers"
	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/queriers"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

// type check to ensure the interface is properly implemented
var (
	_ module.AppModule      = AppModule{}
	_ module.AppModuleBasic = AppModuleBasic{}
)

// AppModuleBasic implements the AppModuleBasic interface for the capability module.
type AppModuleBasic struct {
	cdc codec.Marshaler
}

func NewAppModuleBasic(cdc codec.Marshaler) AppModuleBasic {
	return AppModuleBasic{cdc: cdc}
}
func (AppModuleBasic) RegisterLegacyAminoCodec(amino *codec.LegacyAmino) {
	types.RegisterLegacyAminoCodec(amino)
}

func (AppModuleBasic) RegisterInterfaces(registry sdktypes.InterfaceRegistry) {
	types.RegisterInterfaces(registry)
}

// TODO handle error
func (AppModuleBasic) RegisterGRPCGatewayRoutes(clientCtx client.Context, mux *runtime.ServeMux) {
	types.RegisterQueryHandlerClient(context.Background(), mux, types.NewQueryClient(clientCtx))
}

// Name returns AppModuleBasic name
func (AppModuleBasic) Name() string {
	return types.ModuleName
}

// DefaultGenesis return GenesisState in JSON
func (AppModuleBasic) DefaultGenesis(cdc codec.JSONMarshaler) json.RawMessage {
	return cdc.MustMarshalJSON(types.DefaultGenesis())
}

// ValidateGenesis do validation check of the Genesis
func (AppModuleBasic) ValidateGenesis(cdc codec.JSONMarshaler, cl client.TxEncodingConfig, bz json.RawMessage) error {
	var genState types.GenesisState
	err := cdc.UnmarshalJSON(bz, &genState)
	if err != nil {
		return err
	}
	return genState.Validate()
}

// RegisterRESTRoutes rest routes
func (AppModuleBasic) RegisterRESTRoutes(ctx client.Context, rtr *mux.Router) {
	rest.RegisterRoutes(ctx, rtr, types.StoreKey)
}

// GetQueryCmd get the root query command of this module
func (AppModuleBasic) GetQueryCmd() *cobra.Command {
	pylonsQueryCmd := &cobra.Command{
		Use:   types.RouterKey,
		Short: "Querying commands for the pylons module",
	}
	pylonsQueryCmd.AddCommand(
		query.GetPylonsBalance(),
		query.CheckGoogleIAPOrder(),
		query.CheckPayment(),
		query.GetCookbook(),
		query.GetExecution(),
		query.GetItem(),
		query.GetTrade(),
		query.GetRecipe(),
		query.ListCookbook(),
		query.GetLockedCoins(),
		query.GetLockedCoinDetails(),
		query.ListRecipes(),
		query.ListRecipesByCookbook(),
		query.ListShortenRecipes(),
		query.ListShortenRecipesByCookbook(),
		query.ItemsBySender(),
		query.ListExecutions(),
		query.ListTrade())

	pylonsQueryCmd.PersistentFlags().String("node", "tcp://localhost:26657", "<host>:<port> to Tendermint RPC interface for this chain")

	return pylonsQueryCmd
}

// GetTxCmd get the root tx command of this module
func (AppModuleBasic) GetTxCmd() *cobra.Command {
	txCmd := &cobra.Command{
		Use:   types.RouterKey,
		Short: "Pylons transactions subcommands",
	}

	txCmd.AddCommand(
		tx.CreateAccount(),
		tx.GetPylons(),
		tx.GoogleIAPGetPylons(),
		tx.SendPylons(),
		tx.SendCoins(),
		tx.SendItems(types.StoreKey),
		tx.CreateCookbook(),
		tx.PrivateKeySign(),
		tx.ComputePrivateKey(),
		tx.UpdateCookbook(),
		tx.FiatItem(),
	)

	return txCmd
}

// AppModule manages keeper and bankKeeper along with AppModuleBasic
type AppModule struct {
	AppModuleBasic
	keeper     keeper.Keeper
	bankKeeper bankkeeper.Keeper
}

func (am AppModule) LegacyQuerierHandler(amino *codec.LegacyAmino) sdk.Querier {
	return NewQuerier(am.keeper)
}

func (am AppModule) RegisterServices(cfg module.Configurator) {
	types.RegisterMsgServer(cfg.MsgServer(), handlers.NewMsgServerImpl(am.keeper))
	types.RegisterQueryServer(cfg.QueryServer(), queriers.NewQuerierServerImpl(am.keeper))
}

// NewAppModule creates a new AppModule Object
func NewAppModule(cdc codec.Marshaler, k keeper.Keeper, bankKeeper bankkeeper.Keeper) AppModule {
	return AppModule{
		AppModuleBasic: NewAppModuleBasic(cdc),
		keeper:         k,
		bankKeeper:     bankKeeper,
	}
}

// Name returns AppModule name
func (AppModule) Name() string {
	return types.ModuleName
}

// RegisterInvariants registers invariants
func (am AppModule) RegisterInvariants(ir sdk.InvariantRegistry) {}

// Route returns router key
func (am AppModule) Route() sdk.Route {
	return sdk.NewRoute(types.RouterKey, NewHandler(am.keeper))
}

// NewHandler returns module handler
func (am AppModule) NewHandler() sdk.Handler {
	return NewHandler(am.keeper)
}

// QuerierRoute returns QuerierRoute
func (am AppModule) QuerierRoute() string {
	return types.QuerierRoute
}

// BeginBlock is a begin block function
func (am AppModule) BeginBlock(_ sdk.Context, _ abci.RequestBeginBlock) {}

// EndBlock is a end block function
func (am AppModule) EndBlock(sdk.Context, abci.RequestEndBlock) []abci.ValidatorUpdate {
	return []abci.ValidatorUpdate{}
}

// InitGenesis is a function for init genesis
func (am AppModule) InitGenesis(ctx sdk.Context, cdc codec.JSONMarshaler, data json.RawMessage) []abci.ValidatorUpdate {
	var genesisState types.GenesisState
	cdc.MustUnmarshalJSON(data, &genesisState)
	InitGenesis(ctx, am.keeper, genesisState)
	return []abci.ValidatorUpdate{}
}

// ExportGenesis is a function for export genesis
func (am AppModule) ExportGenesis(ctx sdk.Context, cdc codec.JSONMarshaler) json.RawMessage {
	gs := ExportGenesis(ctx, am.keeper)
	return cdc.MustMarshalJSON(&gs)
}
