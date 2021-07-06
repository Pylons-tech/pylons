package handlers

import (
	"strings"
	"testing"

	"github.com/stretchr/testify/require"

	sdk "github.com/cosmos/cosmos-sdk/types"

	"github.com/Pylons-tech/pylons/x/pylons/keeper"
	"github.com/Pylons-tech/pylons/x/pylons/types"
)

func TestHandlerMsgFiatItem(t *testing.T) {
	tci := keeper.SetupTestCoinInput()
	tci.PlnH = NewMsgServerImpl(tci.PlnK)
	sender, _, _, _ := keeper.SetupTestAccounts(t, tci, types.NewPylon(1000000), nil, nil, nil)

	cases := map[string]struct {
		cookbookName    string
		createCookbook  bool
		recipeDesc      string
		sender          sdk.AccAddress
		desiredItemName string
		desiredError    string
		showError       bool
	}{
		"successful check": {
			cookbookName:    "book000001",
			createCookbook:  true,
			sender:          sender,
			desiredError:    "",
			desiredItemName: "Raichu",
			showError:       false,
		},
	}
	for testName, tc := range cases {
		t.Run(testName, func(t *testing.T) {
			cbData := &types.MsgCreateCookbookResponse{}
			if tc.createCookbook {
				cookbookMsg := types.NewMsgCreateCookbook(
					tc.cookbookName,
					"",
					"this has to meet character limits",
					"SketchyCo",
					"1.0.0",
					"example@example.com",
					1,
					types.DefaultCostPerBlock,
					tc.sender.String(),
				)

				cookbookResult, err := tci.PlnH.CreateCookbook(sdk.WrapSDKContext(tci.Ctx), &cookbookMsg)
				require.NoError(t, err)
				cbData = cookbookResult
				require.True(t, len(cbData.CookbookID) > 0)
			}
			genItem := keeper.GenItem(cbData.CookbookID, tc.sender, tc.desiredItemName)
			msg := types.NewMsgFiatItem(genItem.CookbookID, genItem.Doubles, genItem.Longs, genItem.Strings, tc.sender.String(), 0)
			result, err := tci.PlnH.FiatItem(sdk.WrapSDKContext(tci.Ctx), &msg)

			if !tc.showError {
				require.True(t, len(result.ItemID) > 0)
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
