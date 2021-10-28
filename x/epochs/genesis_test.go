package epochs_test

import (
	"testing"

	"github.com/stretchr/testify/require"

	keepertest "github.com/Pylons-tech/pylons/testutil/keeper"
	"github.com/Pylons-tech/pylons/x/epochs"
	"github.com/Pylons-tech/pylons/x/epochs/types"
)

func TestGenesis(t *testing.T) {
	genesisState := types.GenesisState{
		// this line is used by starport scaffolding # genesis/test/state
	}

	k, ctx := keepertest.EpochsKeeper(t)
	epochs.InitGenesis(ctx, *k, genesisState)
	got := epochs.ExportGenesis(ctx, *k)
	require.NotNil(t, got)

	// this line is used by starport scaffolding # genesis/test/assert
}
