package cmd

import (
	"fmt"
	"testing"

	"github.com/Pylons-tech/pylons/testutil/network"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
)

const testAccountName = "nono"

func TestCreate(t *testing.T) {
	preTestValidate(t)

	net := network.New(t)
	val := net.Validators[0]
	ctx := val.ClientCtx

	debugValidator = val

	// address, err := cli_test.GenerateAddressWithAccount(ctx, t, net)
	// equire.NoError(t, err)

	// skip these - we know they're not real/working tests and i need to make sure i didn't break anything

	t.Run("Bad cookbook", func(t *testing.T) {
		t.Skip()
		args := []string{testAccountName, badPLC}
		cmd := DevCreate()
		out, err := clitestutil.ExecTestCLICmd(ctx, cmd, args)
		fmt.Println("start")
		fmt.Println(out)
		fmt.Println(err)
		fmt.Println("end")
	})

	t.Run("Good cookbook", func(t *testing.T) {
		t.Skip()
		args := []string{testAccountName, goodPLC}
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
