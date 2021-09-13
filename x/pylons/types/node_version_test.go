package types

import (
	"github.com/stretchr/testify/require"
	"testing"
)

func TestNodeVersion(t *testing.T) {
	SetNodeVersionString("test")
	require.Equal(t,"test", GetNodeVersionString())
}

