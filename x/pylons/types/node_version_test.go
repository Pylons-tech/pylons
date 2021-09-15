package types

import (
	"testing"

	"github.com/stretchr/testify/require"
)

func TestNodeVersion(t *testing.T) {
	SetNodeVersionString("test")
	require.Equal(t, "test", GetNodeVersionString())
}
