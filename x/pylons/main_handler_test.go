package pylons

import (
	"github.com/cosmos/cosmos-sdk/testutil/testdata"
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestInvalidMsg(t *testing.T) {
	h := NewHandler(keep.Keeper{})

	_, err := h(sdk.Context{}, testdata.NewTestMsg())
	require.True(t, strings.Contains(err.Error(), "Unrecognized pylons Msg type"))
}
