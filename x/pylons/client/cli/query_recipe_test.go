package cli_test

import (
	"fmt"
	"strconv"
	"testing"

	sdk "github.com/cosmos/cosmos-sdk/types"

	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"
	tmcli "github.com/tendermint/tendermint/libs/cli"
	"google.golang.org/grpc/codes"
	"google.golang.org/grpc/status"

	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func networkWithRecipeObjects(t *testing.T, n int) (*network.Network, []types.Recipe, []types.Cookbook) {
	t.Helper()
	cfg := network.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))

	for i := 0; i < n; i++ {
		state.RecipeList = append(
			state.RecipeList,
			types.Recipe{
				CookbookID:    strconv.Itoa(i),
				ID:            strconv.Itoa(i),
				NodeVersion:   "",
				Name:          "",
				Description:   "",
				Version:       "",
				CoinInputs:    sdk.Coins{},
				ItemInputs:    make([]types.ItemInput, 0),
				Entries:       types.EntriesList{CoinOutputs: []types.CoinOutput{}, ItemOutputs: []types.ItemOutput{}, ItemModifyOutputs: []types.ItemModifyOutput{}},
				Outputs:       make([]types.WeightedOutputs, 0),
				BlockInterval: 0x0,
				Enabled:       false,
				ExtraInfo:     "",
			})
	}
	buf, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buf
	return network.New(t, cfg), state.RecipeList, nil
}

func TestShowRecipe(t *testing.T) {
	net, objs, _ := networkWithRecipeObjects(t, 2)

	ctx := net.Validators[0].ClientCtx
	common := []string{
		fmt.Sprintf("--%s=json", tmcli.OutputFlag),
	}
	for _, tc := range []struct {
		desc string
		id   string
		args []string
		err  error
		obj  types.Recipe
	}{
		{
			desc: "found",
			id:   objs[0].ID,
			args: common,
			obj:  objs[0],
		},
		{
			desc: "not found",
			id:   "not_found",
			args: common,
			err:  status.Error(codes.InvalidArgument, "not found"),
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{tc.id, tc.id}
			args = append(args, tc.args...)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdShowRecipe(), args)
			if tc.err != nil {
				stat, ok := status.FromError(tc.err)
				require.True(t, ok)
				require.ErrorIs(t, stat.Err(), tc.err)
			} else {
				require.NoError(t, err)
				var resp types.QueryGetRecipeResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.NotNil(t, resp.Recipe)
				require.Equal(t, tc.obj, resp.Recipe)
			}
		})
	}
}
