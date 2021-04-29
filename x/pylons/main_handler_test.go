package pylons

import (
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/cosmos/cosmos-sdk/testutil/testdata"
	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestInvalidMsg(t *testing.T) {
	h := NewHandler(keeper.Keeper{})

	_, err := h(sdk.Context{}, testdata.NewTestMsg())
	require.True(t, strings.Contains(err.Error(), "Unrecognized pylons Msg type"))
}
