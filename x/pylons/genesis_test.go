package pylons_test

import (
	"testing"

	keepertest "github.com/Pylons-tech/pylons/testutil/keeper"
	"github.com/Pylons-tech/pylons/x/pylons"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	"github.com/stretchr/testify/require"
)

func TestGenesis(t *testing.T) {
	genesisState := types.GenesisState{
		// this line is used by starport scaffolding # genesis/test/state
	}

	k, ctx := keepertest.PylonsKeeper(t)
	pylons.InitGenesis(ctx, *k, genesisState)
	got := pylons.ExportGenesis(ctx, *k)
	require.NotNil(t, got)

	// this line is used by starport scaffolding # genesis/test/assert
}
