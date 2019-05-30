package pylons

import (
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/cosmos/cosmos-sdk/codec"
)

// RegisterCodec registers concrete types on wire codec
func RegisterCodec(cdc *codec.Codec) {
	cdc.RegisterConcrete(msgs.MsgGetPylons{}, "pylons/GetPylons", nil)
}
