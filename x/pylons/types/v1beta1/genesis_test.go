package v1beta1

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestValidateGenesis(t *testing.T) {
	genesis := DefaultGenesis()
	err := genesis.Validate()
	require.NoError(t, err)

	genesis = NetworkTestGenesis()
	err = genesis.Validate()
	require.NoError(t, err)
}
