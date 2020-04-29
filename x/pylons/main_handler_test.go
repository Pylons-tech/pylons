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

	res, _ := h(sdk.Context{}, sdk.NewTestMsg())
	//require.False(t, res.IsOK())
	require.True(t, strings.Contains(res.Log, "unrecognized pylons Msg type"))
}
