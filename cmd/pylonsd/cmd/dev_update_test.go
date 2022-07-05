package cmd

import (
	"testing"

	util "github.com/Pylons-tech/pylons/testutil/cli"
	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestUpdate(t *testing.T) {
	preTestValidate(t)

	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	cli.ForceSkipConfirm = true

	// we don't need to test the bad cb/rcp cases b/c they fail validation

	t.Run("Cookbook", func(t *testing.T) {
		_, err := util.GenerateAddressWithAccount(ctx, t, net)
		require.NoError(t, err)
		args := []string{"NewUser0", goodPLC}
		cmd := DevUpdate()
		_, err = clitestutil.ExecTestCLICmd(ctx, cmd, args)
		assert.Nil(t, err)
	})

	t.Run("Recipe", func(t *testing.T) {
		args := []string{"NewUser0", goodPLR}
		cmd := DevUpdate()
		_, err := clitestutil.ExecTestCLICmd(ctx, cmd, args)
		assert.Nil(t, err)
	})
}
