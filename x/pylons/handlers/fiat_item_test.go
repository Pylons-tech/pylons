package handlers

import (
	"encoding/json"
	"strings"
	"testing"

	"github.com/MikeSofaer/pylons/x/pylons/keep"
	"github.com/MikeSofaer/pylons/x/pylons/msgs"
	"github.com/MikeSofaer/pylons/x/pylons/types"

	sdk "github.com/cosmos/cosmos-sdk/types"
	"github.com/stretchr/testify/require"
)

func TestHandlerMsgFiatItem(t *testing.T) {
	mockedCoinInput := keep.SetupTestCoinInput()

	sender, _ := sdk.AccAddressFromBech32("cosmos1y8vysg9hmvavkdxpvccv2ve3nssv5avm0kt337")
	mockedCoinInput.Bk.AddCoins(mockedCoinInput.Ctx, sender, types.PremiumTier.Fee)

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
			cbData := CreateCBResponse{}
			if tc.createCookbook {
				cookbookMsg := msgs.NewMsgCreateCookbook(tc.cookbookName, "", "this has to meet character limits", "SketchyCo", "1.0.0", "example@example.com", 1, msgs.DefaultCostPerBlock, tc.sender)
				cookbookResult := HandlerMsgCreateCookbook(mockedCoinInput.Ctx, mockedCoinInput.PlnK, cookbookMsg)

				err := json.Unmarshal(cookbookResult.Data, &cbData)
				require.True(t, err == nil)
				require.True(t, len(cbData.CookbookID) > 0)
			}
			genItem := keep.GenItem(cbData.CookbookID, tc.sender, tc.desiredItemName)
			msg := msgs.NewMsgFiatItem(genItem.CookbookID, genItem.Doubles, genItem.Longs, genItem.Strings, tc.sender)
			result := HandlerMsgFiatItem(mockedCoinInput.Ctx, mockedCoinInput.PlnK, msg)

			if !tc.showError {
				diRespData := FiatItemResponse{}
				err := json.Unmarshal(result.Data, &diRespData)
				require.True(t, err == nil)
				require.True(t, len(diRespData.ItemID) > 0)
			} else {
				require.True(t, strings.Contains(result.Log, tc.desiredError))
			}
		})
	}
}
