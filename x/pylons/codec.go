package pylons

import (
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/codec"
)

// ModuleCdc is the codec for the module
var ModuleCdc = codec.NewLegacyAmino()

func init() {
	RegisterCodec(ModuleCdc)
}

// RegisterCodec registers concrete types on wire codec
func RegisterCodec(cdc *codec.LegacyAmino) {
	cdc.RegisterConcrete(types.MsgCreateAccount{}, "pylons/CreateAccount", nil)
	cdc.RegisterConcrete(types.MsgGetPylons{}, "pylons/GetPylons", nil)
	cdc.RegisterConcrete(types.MsgGoogleIAPGetPylons{}, "pylons/GoogleIAPGetPylons", nil)
	cdc.RegisterConcrete(types.MsgSendCoins{}, "pylons/SendCoins", nil)
	cdc.RegisterConcrete(types.MsgSendItems{}, "pylons/SendItems", nil)
	cdc.RegisterConcrete(types.MsgCreateCookbook{}, "pylons/CreateCookbook", nil)
	cdc.RegisterConcrete(types.MsgUpdateCookbook{}, "pylons/UpdateCookbook", nil)
	cdc.RegisterConcrete(types.MsgCreateRecipe{}, "pylons/CreateRecipe", nil)
	cdc.RegisterConcrete(types.MsgUpdateRecipe{}, "pylons/UpdateRecipe", nil)
	cdc.RegisterConcrete(types.MsgExecuteRecipe{}, "pylons/ExecuteRecipe", nil)
	cdc.RegisterConcrete(types.MsgCheckExecution{}, "pylons/CheckExecution", nil)
	cdc.RegisterConcrete(types.MsgEnableRecipe{}, "pylons/EnableRecipe", nil)
	cdc.RegisterConcrete(types.MsgDisableRecipe{}, "pylons/DisableRecipe", nil)
	cdc.RegisterConcrete(types.MsgFiatItem{}, "pylons/FiatItem", nil)
	cdc.RegisterConcrete(types.MsgUpdateItemString{}, "pylons/UpdateItemString", nil)
	cdc.RegisterConcrete(types.MsgCreateTrade{}, "pylons/CreateTrade", nil)
	cdc.RegisterConcrete(types.MsgFulfillTrade{}, "pylons/FulfillTrade", nil)
	cdc.RegisterConcrete(types.MsgEnableTrade{}, "pylons/EnableTrade", nil)
	cdc.RegisterConcrete(types.MsgDisableTrade{}, "pylons/DisableTrade", nil)

	cdc.RegisterConcrete(types.CoinOutput{}, "pylons/Recipe/CoinOutput", nil)
	cdc.RegisterConcrete(types.ItemModifyOutput{}, "pylons/Recipe/ItemModifyOutput", nil)
	cdc.RegisterConcrete(types.ItemOutput{}, "pylons/Recipe/ItemOutput", nil)
}
