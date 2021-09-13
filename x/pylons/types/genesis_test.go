package types

import (
	"github.com/stretchr/testify/require"
	"testing"
)

func TestValidateGenesis(t *testing.T) {
	genesis := DefaultGenesis()
	err := genesis.Validate()
	require.NoError(t, err)

	genesis = NetworkTestGenesis()
	err = genesis.Validate()
	require.NoError(t, err)
}