package types

import (
	"github.com/cosmos/cosmos-sdk/codec"
	cdctypes "github.com/cosmos/cosmos-sdk/codec/types"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/types/msgservice"
)

func RegisterCodec(cdc *codec.LegacyAmino) {
	// this line is used by starport scaffolding # 2
	cdc.RegisterConcrete(&MsgCreateItem{}, "pylons/CreateItem", nil)
	cdc.RegisterConcrete(&MsgUpdateItem{}, "pylons/UpdateItem", nil)
	cdc.RegisterConcrete(&MsgDeleteItem{}, "pylons/DeleteItem", nil)

	cdc.RegisterConcrete(&MsgCreateRecipe{}, "pylons/CreateRecipe", nil)
	cdc.RegisterConcrete(&MsgUpdateRecipe{}, "pylons/UpdateRecipe", nil)

	cdc.RegisterConcrete(&MsgCreateCookbook{}, "pylons/CreateCookbook", nil)
	cdc.RegisterConcrete(&MsgUpdateCookbook{}, "pylons/UpdateCookbook", nil)

}

func RegisterInterfaces(registry cdctypes.InterfaceRegistry) {
	// this line is used by starport scaffolding # 3
	registry.RegisterImplementations((*sdk.Msg)(nil),
		&MsgCreateItem{},
		&MsgUpdateItem{},
		&MsgDeleteItem{},
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
