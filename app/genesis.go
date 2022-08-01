package app

import (
	"encoding/json"

	"github.com/Pylons-tech/pylons/x/pylons/types/v1beta1"
	banktypes "github.com/cosmos/cosmos-sdk/x/bank/types"

	"github.com/cosmos/cosmos-sdk/codec"
)

// The genesis state of the blockchain is represented here as a map of raw json
// messages key'd by a identifier string.
// The identifier is used to determine which module genesis information belongs
// to so it may be appropriately routed during init chain.
// Within this application default genesis information is retrieved from
// the ModuleBasicManager which populates json from each BasicModule
// object provided to it during init.
type GenesisState map[string]json.RawMessage

// NewDefaultGenesisState generates the default state for the application.
func NewDefaultGenesisState(cdc codec.JSONCodec) GenesisState {
	gs := ModuleBasics.DefaultGenesis(cdc)
	// add default SendEnabled params for paymentProcessors tokens
	bankModuleName := banktypes.ModuleName
	bankModule, ok := gs[bankModuleName]
	if ok {
		var bankGenesisState banktypes.GenesisState
		cdc.MustUnmarshalJSON(bankModule, &bankGenesisState)
		for _, token := range v1beta1.DefaultPaymentProcessorsTokensBankParams {
			bankGenesisState.Params = bankGenesisState.Params.SetSendEnabledParam(token.Denom, token.Enabled)
		}
		gs[bankModuleName] = cdc.MustMarshalJSON(&bankGenesisState)
	}
	return gs
}
