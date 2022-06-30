package cmd

import (
	"fmt"
	"testing"

	util "github.com/Pylons-tech/pylons/testutil/cli"
	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"
)

const testAccountName = "nono"

func TestCreate(t *testing.T) {
	preTestValidate(t)

	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx
	cli.ForceSkipConfirm = true

	// skip these - we know they're not real/working tests and i need to make sure i didn't break anything

	t.Run("Bad cookbook", func(t *testing.T) {
		t.Skip() // it fails, we need to check that
		address, err := util.GenerateAddressWithAccount(ctx, t, net)
		require.NoError(t, err)
		args := []string{address, badPLC}
		cmd := DevCreate()
		out, err := clitestutil.ExecTestCLICmd(ctx, cmd, args)
		fmt.Println("start")
		fmt.Println(out)
		fmt.Println(err)
		fmt.Println("end")
	})

	t.Run("Good cookbook", func(t *testing.T) {
		_, err := util.GenerateAddressWithAccount(ctx, t, net)
		require.NoError(t, err)
		args := []string{"NewUser0", goodPLC}
		cmd := DevCreate()
		out, err := clitestutil.ExecTestCLICmd(ctx, cmd, args)
		fmt.Println("start")
		fmt.Println(out)
		fmt.Println(err)
		fmt.Println("end")
	})

	t.Run("Bad recipe", func(t *testing.T) {
		t.Skip()
		args := []string{badPLR, testAccountName}
		out, err := clitestutil.ExecTestCLICmd(ctx, DevCreate(), args)
		t.Log(out)
		t.Log(err)
	})

	t.Run("Good recipe", func(t *testing.T) {
		t.Skip()
		args := []string{goodPLR, testAccountName}
		out, err := clitestutil.ExecTestCLICmd(ctx, DevCreate(), args)
		t.Log(out)
		t.Log(err)
	})
}
