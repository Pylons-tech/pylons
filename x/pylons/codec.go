package pylons

import (
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
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
	cdc.RegisterConcrete(msgs.MsgCreateAccount{}, "pylons/CreateAccount", nil)
	cdc.RegisterConcrete(msgs.MsgGetPylons{}, "pylons/GetPylons", nil)
	cdc.RegisterConcrete(msgs.MsgGoogleIAPGetPylons{}, "pylons/GoogleIAPGetPylons", nil)
	cdc.RegisterConcrete(msgs.MsgSendCoins{}, "pylons/SendCoins", nil)
	cdc.RegisterConcrete(msgs.MsgSendItems{}, "pylons/SendItems", nil)
	cdc.RegisterConcrete(msgs.MsgCreateCookbook{}, "pylons/CreateCookbook", nil)
	cdc.RegisterConcrete(msgs.MsgUpdateCookbook{}, "pylons/UpdateCookbook", nil)
	cdc.RegisterConcrete(msgs.MsgCreateRecipe{}, "pylons/CreateRecipe", nil)
	cdc.RegisterConcrete(msgs.MsgUpdateRecipe{}, "pylons/UpdateRecipe", nil)
	cdc.RegisterConcrete(msgs.MsgExecuteRecipe{}, "pylons/ExecuteRecipe", nil)
	cdc.RegisterConcrete(msgs.MsgCheckExecution{}, "pylons/CheckExecution", nil)
	cdc.RegisterConcrete(msgs.MsgEnableRecipe{}, "pylons/EnableRecipe", nil)
	cdc.RegisterConcrete(msgs.MsgDisableRecipe{}, "pylons/DisableRecipe", nil)
	cdc.RegisterConcrete(msgs.MsgFiatItem{}, "pylons/FiatItem", nil)
	cdc.RegisterConcrete(msgs.MsgUpdateItemString{}, "pylons/UpdateItemString", nil)
	cdc.RegisterConcrete(msgs.MsgCreateTrade{}, "pylons/CreateTrade", nil)
	cdc.RegisterConcrete(msgs.MsgFulfillTrade{}, "pylons/FulfillTrade", nil)
	cdc.RegisterConcrete(msgs.MsgEnableTrade{}, "pylons/EnableTrade", nil)
	cdc.RegisterConcrete(msgs.MsgDisableTrade{}, "pylons/DisableTrade", nil)

	cdc.RegisterConcrete(types.CoinOutput{}, "pylons/Recipe/CoinOutput", nil)
	cdc.RegisterConcrete(types.ItemModifyOutput{}, "pylons/Recipe/ItemModifyOutput", nil)
	cdc.RegisterConcrete(types.ItemOutput{}, "pylons/Recipe/ItemOutput", nil)

	cdc.RegisterInterface((*types.Entry)(nil), nil)
}
