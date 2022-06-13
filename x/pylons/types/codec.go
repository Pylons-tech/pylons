package types

import (
	"github.com/cosmos/cosmos-sdk/codec"
	cdctypes "github.com/cosmos/cosmos-sdk/codec/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/msgservice"
)

func RegisterCodec(cdc *codec.LegacyAmino) {
	cdc.RegisterConcrete(&MsgBurnDebtToken{}, "pylons/BurnDebtToken", nil)

	cdc.RegisterConcrete(&MsgUpdateAccount{}, "pylons/UpdateAccount", nil)
	cdc.RegisterConcrete(&MsgCreateAccount{}, "pylons/CreateAccount", nil)

	cdc.RegisterConcrete(&MsgFulfillTrade{}, "pylons/FulfillTrade", nil)
	cdc.RegisterConcrete(&MsgCreateTrade{}, "pylons/CreateTrade", nil)
	cdc.RegisterConcrete(&MsgCancelTrade{}, "pylons/CancelTrade", nil)

	cdc.RegisterConcrete(&MsgCompleteExecutionEarly{}, "pylons/CompleteExecutionEarly", nil)

	cdc.RegisterConcrete(&MsgTransferCookbook{}, "pylons/TransferCookbook", nil)

	cdc.RegisterConcrete(&MsgGoogleInAppPurchaseGetCoins{}, "pylons/GoogleInAppPurchaseGetPylons", nil)

	cdc.RegisterConcrete(&MsgSendItems{}, "pylons/SendItems", nil)

	cdc.RegisterConcrete(&MsgExecuteRecipe{}, "pylons/ExecuteRecipe", nil)

	cdc.RegisterConcrete(&MsgSetItemString{}, "pylons/SetItemString", nil)

	cdc.RegisterConcrete(&MsgCreateRecipe{}, "pylons/CreateRecipe", nil)
	cdc.RegisterConcrete(&MsgUpdateRecipe{}, "pylons/UpdateRecipe", nil)

	cdc.RegisterConcrete(&MsgCreateCookbook{}, "pylons/CreateCookbook", nil)
	cdc.RegisterConcrete(&MsgUpdateCookbook{}, "pylons/UpdateCookbook", nil)
}

func RegisterInterfaces(registry cdctypes.InterfaceRegistry) {
	registry.RegisterImplementations((*sdk.Msg)(nil),
		&MsgBurnDebtToken{},
	)
	registry.RegisterImplementations((*sdk.Msg)(nil),
		&MsgUpdateAccount{},
	)
	registry.RegisterImplementations((*sdk.Msg)(nil),
		&MsgFulfillTrade{},
	)
	registry.RegisterImplementations((*sdk.Msg)(nil),
		&MsgCreateTrade{},
		&MsgCancelTrade{},
	)
	registry.RegisterImplementations((*sdk.Msg)(nil),
		&MsgCompleteExecutionEarly{},
	)
	registry.RegisterImplementations((*sdk.Msg)(nil),
		&MsgTransferCookbook{},
	)
	registry.RegisterImplementations((*sdk.Msg)(nil),
		&MsgGoogleInAppPurchaseGetCoins{},
	)
	registry.RegisterImplementations((*sdk.Msg)(nil),
		&MsgCreateAccount{},
	)
	registry.RegisterImplementations((*sdk.Msg)(nil),
		&MsgSendItems{},
	)
	registry.RegisterImplementations((*sdk.Msg)(nil),
		&MsgExecuteRecipe{},
	)
	registry.RegisterImplementations((*sdk.Msg)(nil),
		&MsgSetItemString{},
	)
	registry.RegisterImplementations((*sdk.Msg)(nil),
		&MsgCreateRecipe{},
		&MsgUpdateRecipe{},
	)
	registry.RegisterImplementations((*sdk.Msg)(nil),
		&MsgCreateCookbook{},
		&MsgUpdateCookbook{},
	)

	msgservice.RegisterMsgServiceDesc(registry, &_Msg_serviceDesc)
}

var (
	// nolint: deadcode, unused
	amino     = codec.NewLegacyAmino()
	ModuleCdc = codec.NewProtoCodec(cdctypes.NewInterfaceRegistry())
)
