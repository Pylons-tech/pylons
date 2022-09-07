package cli_test

import (
	"testing"

	"github.com/Pylons-tech/pylons/testutil/network"
	"github.com/Pylons-tech/pylons/x/pylons/client/cli"
	"github.com/Pylons-tech/pylons/x/pylons/types"
	clitestutil "github.com/cosmos/cosmos-sdk/testutil/cli"
	"github.com/stretchr/testify/require"
)

func settingRecipeObject(t *testing.T) (*network.Network, *types.Recipe) {
	t.Helper()
	cfg := network.DefaultConfig()
	state := types.GenesisState{}
	require.NoError(t, cfg.Codec.UnmarshalJSON(cfg.GenesisState[types.ModuleName], &state))
	recipe := types.Recipe{
		CookbookId: "testCookbookId",
		Id:         "testId",
	}
	state.RecipeList = append(state.RecipeList, recipe)

	buffer, err := cfg.Codec.MarshalJSON(&state)
	require.NoError(t, err)
	cfg.GenesisState[types.ModuleName] = buffer
	return network.New(t, cfg), &recipe
}

func TestCmdShowRecipe(t *testing.T) {
	net, recipe := settingRecipeObject(t)
	ctx := net.Validators[0].ClientCtx

	for _, tc := range []struct {
		desc       string
		cookbookId string
		id         string
		shouldErr  bool
	}{
		{
			desc:       "Valid",
			cookbookId: recipe.CookbookId,
			id:         recipe.Id,
			shouldErr:  false,
		},
		{
			desc:       "Invalid CookbookId",
			cookbookId: "Invalid",
			id:         recipe.Id,
			shouldErr:  true,
		},
		{
			desc:       "Invalid Id",
			cookbookId: recipe.CookbookId,
			id:         "Invalid",
			shouldErr:  true,
		},
	} {
		tc := tc
		t.Run(tc.desc, func(t *testing.T) {
			args := []string{}
			args = append(args, tc.cookbookId, tc.id)
			out, err := clitestutil.ExecTestCLICmd(ctx, cli.CmdShowRecipe(), args)
			if tc.shouldErr {
				require.Error(t, err)
				var resp types.QueryGetRecipeResponse
				require.Error(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
			} else {
				require.NoError(t, err)
				var resp types.QueryGetRecipeResponse
				require.NoError(t, net.Config.Codec.UnmarshalJSON(out.Bytes(), &resp))
				require.NotNil(t, resp.Recipe)
				require.Equal(t, resp.Recipe.CookbookId, tc.cookbookId)
				require.Equal(t, resp.Recipe.Id, tc.id)
			}
		})
	}
}
