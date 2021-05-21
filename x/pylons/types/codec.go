package types

import (
	"github.com/cosmos/cosmos-sdk/codec"
	codectypes "github.com/cosmos/cosmos-sdk/codec/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/msgservice"
)

func RegisterLegacyAminoCodec(cdc *codec.LegacyAmino) {
	cdc.RegisterConcrete(MsgCreateAccount{}, "pylons/CreateAccount", nil)
	cdc.RegisterConcrete(MsgGetPylons{}, "pylons/GetPylons", nil)
	cdc.RegisterConcrete(MsgGoogleIAPGetPylons{}, "pylons/GoogleIAPGetPylons", nil)
	cdc.RegisterConcrete(MsgSendCoins{}, "pylons/SendCoins", nil)
	cdc.RegisterConcrete(MsgSendItems{}, "pylons/SendItems", nil)
	cdc.RegisterConcrete(MsgCreateCookbook{}, "pylons/CreateCookbook", nil)
	cdc.RegisterConcrete(MsgUpdateCookbook{}, "pylons/UpdateCookbook", nil)
	cdc.RegisterConcrete(MsgCreateRecipe{}, "pylons/CreateRecipe", nil)
	cdc.RegisterConcrete(MsgUpdateRecipe{}, "pylons/UpdateRecipe", nil)
	cdc.RegisterConcrete(MsgExecuteRecipe{}, "pylons/ExecuteRecipe", nil)
	cdc.RegisterConcrete(MsgCheckExecution{}, "pylons/CheckExecution", nil)
	cdc.RegisterConcrete(MsgEnableRecipe{}, "pylons/EnableRecipe", nil)
	cdc.RegisterConcrete(MsgDisableRecipe{}, "pylons/DisableRecipe", nil)
	cdc.RegisterConcrete(MsgFiatItem{}, "pylons/FiatItem", nil)
	cdc.RegisterConcrete(MsgUpdateItemString{}, "pylons/UpdateItemString", nil)
	cdc.RegisterConcrete(MsgCreateTrade{}, "pylons/CreateTrade", nil)
	cdc.RegisterConcrete(MsgFulfillTrade{}, "pylons/FulfillTrade", nil)
	cdc.RegisterConcrete(MsgEnableTrade{}, "pylons/EnableTrade", nil)
	cdc.RegisterConcrete(MsgDisableTrade{}, "pylons/DisableTrade", nil)

	cdc.RegisterConcrete(CoinOutput{}, "pylons/Recipe/CoinOutput", nil)
	cdc.RegisterConcrete(ItemModifyOutput{}, "pylons/Recipe/ItemModifyOutput", nil)
	cdc.RegisterConcrete(ItemOutput{}, "pylons/Recipe/ItemOutput", nil)
}

func RegisterInterfaces(registry codectypes.InterfaceRegistry) {
	registry.RegisterImplementations(
		(*sdk.Msg)(nil),
		&MsgCreateAccount{},
		&MsgGetPylons{},
		&MsgGoogleIAPGetPylons{},
		&MsgStripeGetPylons{},
		&MsgSendCoins{},
		&MsgSendItems{},
		&MsgCreateCookbook{},
		&MsgUpdateCookbook{},
		&MsgCreateRecipe{},
		&MsgUpdateRecipe{},
		&MsgExecuteRecipe{},
		&MsgDisableRecipe{},
		&MsgEnableRecipe{},
		&MsgCheckExecution{},
		&MsgFiatItem{},
		&MsgUpdateItemString{},
		&MsgCreateTrade{},
		&MsgFulfillTrade{},
		&MsgDisableTrade{},
		&MsgEnableTrade{},
	)
	msgservice.RegisterMsgServiceDesc(registry, &_Msg_serviceDesc)
}

var (
	amino     = codec.NewLegacyAmino()
	ModuleCdc = codec.NewAminoCodec(amino)
)

func init() {
	RegisterLegacyAminoCodec(amino)
	amino.Seal()
}
