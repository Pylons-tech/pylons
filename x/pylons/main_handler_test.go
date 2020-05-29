package pylons

import (
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestInvalidMsg(t *testing.T) {
	h := NewHandler(keep.Keeper{})

	_, err := h(sdk.Context{}, sdk.NewTestMsg())
	require.True(t, strings.Contains(err.Error(), "Unrecognized pylons Msg type"))
}
