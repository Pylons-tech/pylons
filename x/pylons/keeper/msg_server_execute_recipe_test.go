package keeper_test

import (
	"fmt"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func (suite *IntegrationTestSuite) TestExecuteRecipe() {
	k := suite.k
	ctx := suite.ctx
	require := suite.Require()

	srv := keeper.NewMsgServerImpl(k)
	wctx := sdk.WrapSDKContext(ctx)

	creator := "A"
	for i := 0; i < 5; i++ {
		idx := fmt.Sprintf("%d", i)
		cookbook := &types.MsgCreateCookbook{
			Creator:      creator,
			ID:           idx,
			Name:         "testCookbookName",
			Description:  "descdescdescdescdescdesc",
			Developer:    "",
			Version:      "v0.0.1",
			SupportEmail: "test@email.com",
			Enabled:      true,
		}
		_, err := srv.CreateCookbook(wctx, cookbook)
		require.NoError(err)
		recipe := &types.MsgCreateRecipe{
			Creator:       creator,
			CookbookID:    idx,
			ID:            idx,
			Name:          "testRecipeName",
			Description:   "decdescdescdescdescdescdescdesc",
			Version:       "v0.0.1",
			CoinInputs:    nil,
			ItemInputs:    nil,
			Entries:       types.EntriesList{},
			Outputs:       nil,
			BlockInterval: 0,
			CostPerBlock: sdk.Coin{Denom: "test", Amount: sdk.ZeroInt()},
			Enabled:       true,
			ExtraInfo:     "",
		}
		_, err = srv.CreateRecipe(wctx, recipe)
		require.NoError(err)
		rst, found := k.GetRecipe(ctx, recipe.CookbookID, recipe.ID)
		require.True(found)
		require.Equal(recipe.ID, rst.ID)

		execution := &types.MsgExecuteRecipe{
			Creator:         creator,
			CookbookID:      idx,
			RecipeID:        idx,
			CoinInputsIndex: 0,
			ItemIDs:         nil,
		}
		_, err = srv.ExecuteRecipe(wctx, execution)
		require.NoError(err)

		completed, pending := k.GetAllExecutionByRecipe(ctx, recipe.CookbookID, recipe.ID)
		require.Equal(0, len(completed))
		require.Equal(1, len(pending))
	}
}
