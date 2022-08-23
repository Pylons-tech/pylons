package app

import (
	"github.com/CosmWasm/wasmd/x/wasm"
	wasmkeeper "github.com/CosmWasm/wasmd/x/wasm/keeper"
	servertypes "github.com/cosmos/cosmos-sdk/server/types"
	"github.com/prometheus/client_golang/prometheus"
	"github.com/spf13/cast"
)

const (
	// DefaultInstanceCost is initially set the same as in wasmd
	DefaultInstanceCost uint64 = 60_000
	// DefaultCompileCost set to a large number for testing
	DefaultCompileCost uint64 = 100
)

// GasRegisterConfig is defaults plus a custom compile amount
func GasRegisterConfig() wasmkeeper.WasmGasRegisterConfig {
	gasConfig := wasmkeeper.DefaultGasRegisterConfig()
	gasConfig.InstanceCost = DefaultInstanceCost
	gasConfig.CompileCost = DefaultCompileCost

	return gasConfig
}

func NewWasmGasRegister() wasmkeeper.WasmGasRegister {
	return wasmkeeper.NewWasmGasRegister(GasRegisterConfig())
}

func GetWasmOpts(appOpts servertypes.AppOptions) []wasm.Option {
	var wasmOpts []wasm.Option
	if cast.ToBool(appOpts.Get("telemetry.enabled")) {
		wasmOpts = append(wasmOpts, wasmkeeper.WithVMCacheMetrics(prometheus.DefaultRegisterer))
	}

	wasmOpts = append(wasmOpts, wasmkeeper.WithGasRegister(NewWasmGasRegister()))

	return wasmOpts
}
