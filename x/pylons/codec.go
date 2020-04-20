package pylons

import (
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/cosmos/cosmos-sdk/codec"
)

// RegisterCodec registers concrete types on wire codec
func RegisterCodec(cdc *codec.Codec) {
	cdc.RegisterConcrete(msgs.MsgGetPylons{}, "pylons/GetPylons", nil)
	cdc.RegisterConcrete(msgs.MsgSendPylons{}, "pylons/SendPylons", nil)
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
	cdc.RegisterConcrete(types.ItemOutput{}, "pylons/Recipe/ItemOutput", nil)

	cdc.RegisterInterface((*types.Entry)(nil), nil)
}
