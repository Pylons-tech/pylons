package pylons

import (
	"github.com/Pylons-tech/pylons/x/pylons/keep"
	sdk "github.com/cosmos/cosmos-sdk/types"
)

// GenesisState empty genesis for pylons
type GenesisState struct {
}

func NewGenesisState() GenesisState {
	return GenesisState{}
}

func ValidateGenesis(data GenesisState) error {
	return nil
}

func DefaultGenesisState() GenesisState {
	return GenesisState{}
}

func InitGenesis(ctx sdk.Context, keeper keep.Keeper, data GenesisState) {
}

func ExportGenesis(ctx sdk.Context, k keep.Keeper) GenesisState {
	return GenesisState{}
}
