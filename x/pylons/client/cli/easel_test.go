package cli_test

import (
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"
	"testing"
)

func createEaselCookbook(t *testing.T, simInfo *loudBasicSim) {

	cbFields := []string{
		"Legend of the Undead Dragon",
		"Cookbook for running pylons recreation of LOUD",
		"Pylons Inc",
		"v0.0.1",
		"alex@shmeeload.xyz",
		"{\"denom\": \"pylons\", \"amount\": \"1\"}",
		"true",
	}

	// create LOUD cookbook
	args := []string{cookbookID}
	args = append(args, cbFields...)
	args = append(args, simInfo.common...)
	_, err := clitestutil.ExecTestCLICmd(simInfo.ctx, cli.CmdCreateCookbook(), args)
	require.NoError(t, err)
}