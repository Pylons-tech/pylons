package params

import (
	"github.com/Pylons-tech/pylons/app"
	"github.com/cosmos/cosmos-sdk/client"
	"github.com/cosmos/cosmos-sdk/codec"
	"github.com/cosmos/cosmos-sdk/codec/types"
	"github.com/cosmos/cosmos-sdk/std"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/cosmos/cosmos-sdk/x/auth/tx"
	vestingtypes "github.com/cosmos/cosmos-sdk/x/auth/vesting/types"
)

// EncodingConfig specifies the concrete encoding types to use for a given app.
// This is provided for compatibility between protobuf and amino implementations.
type EncodingConfig struct {
	InterfaceRegistry types.InterfaceRegistry
	Marshaler         codec.Marshaler
	TxConfig          client.TxConfig
	Amino             *codec.LegacyAmino
}

func MakeEncodingConfig() EncodingConfig {
	encodingConfig := MakeConfig()
	std.RegisterLegacyAminoCodec(encodingConfig.Amino)
	std.RegisterInterfaces(encodingConfig.InterfaceRegistry)
	app.ModuleBasics.RegisterLegacyAminoCodec(encodingConfig.Amino)
	app.ModuleBasics.RegisterInterfaces(encodingConfig.InterfaceRegistry)
	return encodingConfig
}
func MakeConfig() EncodingConfig {
	amino := MakeCodec()
	interfaceRegistry := types.NewInterfaceRegistry()
	marshaler := codec.NewProtoCodec(interfaceRegistry)
	txCfg := tx.NewTxConfig(marshaler, tx.DefaultSignModes)

	return EncodingConfig{
		InterfaceRegistry: interfaceRegistry,
		Marshaler:         marshaler,
		TxConfig:          txCfg,
		Amino:             amino,
	}
}

// MakeCodec make codec for message marshal/unmarshal
func MakeCodec() *codec.LegacyAmino {
	var cdc = codec.NewLegacyAmino()

	app.ModuleBasics.RegisterLegacyAminoCodec(cdc)
	vestingtypes.RegisterLegacyAminoCodec(cdc)
	sdk.RegisterLegacyAminoCodec(cdc)
	codec.RegisterEvidences(cdc)

	return cdc
}
