package handlers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/Pylons-tech/pylons/x/pylons/keep"
	"github.com/Pylons-tech/pylons/x/pylons/msgs"
	"github.com/Pylons-tech/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgFiatItem(t *testing.T) {
	tci := keep.SetupTestCoinInput()
	sender, _ := keep.SetupTestAccounts(t, tci, types.NewPylon(1000000))

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
			cbData := CreateCookbookResponse{}
			if tc.createCookbook {
				cookbookMsg := msgs.NewMsgCreateCookbook(tc.cookbookName, "", "this has to meet character limits", "SketchyCo", "1.0.0", "example@example.com", 1, msgs.DefaultCostPerBlock, tc.sender)
				cookbookResult, err := HandlerMsgCreateCookbook(tci.Ctx, tci.PlnK, cookbookMsg)
				require.True(t, err == nil)
				err = json.Unmarshal(cookbookResult.Data, &cbData)
				require.True(t, err == nil)
				require.True(t, len(cbData.CookbookID) > 0)
			}
			genItem := keep.GenItem(cbData.CookbookID, tc.sender, tc.desiredItemName)
			msg := msgs.NewMsgFiatItem(genItem.CookbookID, genItem.Doubles, genItem.Longs, genItem.Strings, tc.sender, 0)
			result, err := HandlerMsgFiatItem(tci.Ctx, tci.PlnK, msg)

			if !tc.showError {
				diRespData := FiatItemResponse{}
				err := json.Unmarshal(result.Data, &diRespData)
				require.True(t, err == nil)
				require.True(t, len(diRespData.ItemID) > 0)
			} else {
				require.True(t, strings.Contains(err.Error(), tc.desiredError))
			}
		})
	}
}
